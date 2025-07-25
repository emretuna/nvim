local M = {}

-- Constants
local BIG_FILE_SIZE = 1.5 * 1024 * 1024 -- 1.5MB
local uv = vim.uv or vim.loop

-- Function to detect big files
local function detect_bigfile(path, buf)
  if vim.bo[buf] and vim.bo[buf].filetype ~= 'bigfile' and path and vim.fn.getfsize(path) > BIG_FILE_SIZE then
    return 'bigfile'
  end
  return nil
end

vim.filetype.add {
  pattern = { ['.*'] = detect_bigfile },
}

-- Handle big files
local function on_bigfile(ev)
  vim.b.minianimate_disable = true
  vim.schedule(function()
    vim.bo[ev.buf].syntax = ev.ft
  end)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ':p:~:.')
  vim.notify(('Big file detected `%s`.'):format(path))
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('on_bigfile', { clear = true }),
  pattern = 'bigfile',
  callback = function(ev)
    vim.api.nvim_buf_call(ev.buf, function()
      on_bigfile { buf = ev.buf, ft = vim.filetype.match { buf = ev.buf } or '' }
    end)
  end,
})

-- File rename with LSP
local function realpath(path)
  return vim.fs.normalize(uv.fs_realpath(path) or path)
end

function M.rename_file(opts)
  opts = opts or {}
  local buf = vim.api.nvim_get_current_buf()
  if opts.file then
    buf = vim.fn.bufadd(opts.file)
  end
  local old = assert(realpath(vim.api.nvim_buf_get_name(buf)))
  local root = assert(realpath(uv.cwd() or '.'))
  if old:find(root, 1, true) ~= 1 then
    root = vim.fn.fnamemodify(old, ':p:h')
  end
  local extra = old:sub(#root + 2)

  vim.ui.input({
    prompt = 'New File Name: ',
    default = extra,
    completion = 'file',
  }, function(new)
    if not new or new == '' or new == extra then
      return
    end
    new = vim.fs.normalize(root .. '/' .. new)
    vim.fn.mkdir(vim.fs.dirname(new), 'p')
    M.on_rename_file(old, new, function()
      vim.fn.rename(old, new)
      if not opts.on_rename then
        vim.cmd.edit(new)
      end
      vim.api.nvim_buf_delete(buf, { force = true })
      vim.fn.delete(old)
      if opts.on_rename then
        opts.on_rename(new, old)
      end
    end)
  end)
end

function M.on_rename_file(from, to, rename)
  local changes = { files = { { oldUri = vim.uri_from_fname(from), newUri = vim.uri_from_fname(to) } } }
  local clients = (vim.lsp.get_clients or vim.lsp.get_active_clients)()
  for _, client in ipairs(clients) do
    if client.supports_method 'workspace/willRenameFiles' then
      local resp = client.request_sync('workspace/willRenameFiles', changes, 1000, 0)
      if resp and resp.result then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end
  if rename then
    rename()
  end
  for _, client in ipairs(clients) do
    if client.supports_method 'workspace/didRenameFiles' then
      client.notify('workspace/didRenameFiles', changes)
    end
  end
  vim.notify('File renamed successfully!', vim.log.levels.INFO)
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesActionRename',
  callback = function(event)
    M.on_rename_file(event.data.from, event.data.to)
  end,
})

vim.api.nvim_create_user_command('WorkspaceRenameFile', M.rename_file, { desc = 'Workspace Rename File' })

-- Toggle term
M.state = {
  horizontal = nil,
  float = nil,
  lazygit = nil,
  claude_monitor = nil,
}

function M.toggle_horizontal()
  local term = M.state.horizontal
  -- If already open, close it
  if term and term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_close(term.win, true)
    M.state.horizontal.win = nil
    return
  end

  -- Create terminal buffer if missing
  if not term or not term.buf or not vim.api.nvim_buf_is_valid(term.buf) then
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd 'terminal'
    end)
    -- Make buffer unlisted and set buffer name
    vim.bo[bufnr].buflisted = false
    vim.api.nvim_buf_set_name(bufnr, 'term://horizontal-term')
    vim.bo[bufnr].filetype = 'custom_term'
    M.state.horizontal = { buf = bufnr }
  end

  -- Open a new horizontal split
  vim.cmd 'belowright split'
  vim.cmd 'resize 10'
  local win = vim.api.nvim_get_current_win()

  -- Set the buffer in the window
  vim.api.nvim_win_set_buf(win, M.state.horizontal.buf)
  M.state.horizontal.win = win
  vim.cmd 'startinsert'
end

function M.toggle_float()
  local term = M.state.float
  if term and term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_close(term.win, true)
    M.state.float.win = nil
    return
  end

  if not term or not term.buf or not vim.api.nvim_buf_is_valid(term.buf) then
    -- Create a new buffer without opening a window
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd 'terminal'
    end)
    -- Make buffer unlisted and set buffer name
    vim.bo[bufnr].buflisted = false
    vim.api.nvim_buf_set_name(bufnr, 'term://float-term')
    vim.bo[bufnr].filetype = 'custom_term'
    M.state.float = { buf = bufnr }
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(M.state.float.buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = vim.g.border_style or 'rounded',
  })

  M.state.float.win = win
  vim.cmd 'startinsert'
end

vim.api.nvim_create_user_command('FloatTerm', M.toggle_float, { desc = 'Toggle Floating terminal' })
vim.api.nvim_create_user_command('HorizontalTerm', M.toggle_horizontal, { desc = 'Toggle Floating terminal' })

function M.toggle_lazygit()
  if vim.fn.finddir('.git', vim.fn.getcwd() .. ';') == '' then
    vim.notify('Not a git repository', vim.log.levels.WARN)
    return
  end

  local term = M.state.lazygit
  -- If already open, close it
  if term and term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_close(term.win, true)
    M.state.lazygit.win = nil
    return
  end

  -- Create terminal buffer if missing
  if not term or not term.buf or not vim.api.nvim_buf_is_valid(term.buf) then
    local config_path = vim.fn.stdpath 'cache' .. '/lazygit-theme.yml'
    local config_arg = string.format('--use-config-file="%s"', config_path)
    local bufnr = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd('terminal lazygit ' .. config_arg)
    end)

    -- Make buffer unlisted and set buffer name
    vim.bo[bufnr].buflisted = false
    vim.bo[bufnr].filetype = 'lazygit_term'

    -- Set up TermClose autocommand
    vim.api.nvim_create_autocmd('TermClose', {
      buffer = bufnr,
      callback = function()
        vim.schedule(function()
          if M.state.lazygit and M.state.lazygit.win and vim.api.nvim_win_is_valid(M.state.lazygit.win) then
            vim.api.nvim_win_close(M.state.lazygit.win, true)
            M.state.lazygit.win = nil
          end
          -- Clear the buffer reference when terminal closes
          if M.state.lazygit then
            M.state.lazygit.buf = nil
          end
        end)
      end,
    })

    M.state.lazygit = { buf = bufnr }
  end
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  local win = vim.api.nvim_open_win(M.state.lazygit.buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = vim.g.border_style,
  })
  M.state.lazygit.win = win
  vim.api.nvim_win_call(win, function()
    vim.cmd 'startinsert'
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.foldcolumn = '0'
    vim.opt_local.statuscolumn = ''
  end)
end

vim.api.nvim_create_user_command('LazyGit', M.toggle_lazygit, { desc = 'Toggle LazyGit terminal' })
-- Claude Monitor
-- install first using: `uv tool install claude-monitor`

function M.toggle_claude_monitor()
  local term = M.state.claude_monitor
  if term and term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_close(term.win, true)
    M.state.claude_monitor.win = nil
    return
  end

  if not term or not term.buf or not vim.api.nvim_buf_is_valid(term.buf) then
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd 'terminal claude-monitor'
    end)
    vim.bo[bufnr].buflisted = false
    vim.api.nvim_buf_set_name(bufnr, 'term://claude-monitor')
    vim.bo[bufnr].filetype = 'claude_monitor_term'
    M.state.claude_monitor = { buf = bufnr }
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(M.state.claude_monitor.buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = vim.g.border_style or 'rounded',
  })

  M.state.claude_monitor.win = win
  vim.cmd 'startinsert'
end

vim.api.nvim_create_user_command('ClaudeMonitor', M.toggle_claude_monitor, { desc = 'Toggle Claude Monitor terminal' })

-- Generate LazyGit theme based on selected colorscheme
-- Get color settings
local function get_color(v)
  local color = {}
  for _, c in ipairs { 'fg', 'bg' } do
    if v[c] then
      local name, hl = v[c], vim.api.nvim_get_hl(0, { name = v[c], link = false })
      local hl_color = (c == 'fg' and hl and hl.fg) or (c == 'bg' and hl and hl.bg)
      if hl_color then
        table.insert(color, string.format('#%06x', hl_color))
      end
    end
  end
  if v.bold then
    table.insert(color, 'bold')
  end
  return color
end

-- Generate LazyGit theme YAML
local function generate_yaml_content(theme, authorColors)
  local lines = {
    'gui:',
    '  nerdFontsVersion: "3"',
    '  theme:',
  }
  for key, value in pairs(theme) do
    table.insert(lines, string.format('    %s:', key))
    for _, v in ipairs(value) do
      table.insert(lines, string.format("      - '%s'", v))
    end
  end
  table.insert(lines, '    authorColors:')
  table.insert(lines, string.format("      '*': '%s'", authorColors['*']))
  table.insert(lines, 'os:')
  table.insert(lines, "  editPreset: 'nvim-remote'")
  return table.concat(lines, '\n') .. '\n'
end

function M.generate_lazygit_theme()
  local current_theme = vim.g.colors_name or 'default'
  if current_theme == vim.g.last_lazygit_theme then
    return
  end
  vim.g.last_lazygit_theme = current_theme

  local theme = {
    [241] = get_color { fg = 'Special' },
    activeBorderColor = get_color { fg = 'MatchParen', bold = true },
    inactiveBorderColor = get_color { fg = 'FloatBorder' },
    optionsTextColor = get_color { fg = 'Function' },
    selectedLineBgColor = get_color { bg = 'Visual' },
    cherryPickedCommitBgColor = get_color { fg = 'Identifier' },
    cherryPickedCommitFgColor = get_color { fg = 'Function' },
    unstagedChangesColor = get_color { fg = 'DiagnosticError' },
    defaultFgColor = get_color { fg = 'Normal' },
    searchingActiveBorderColor = get_color { fg = 'MatchParen', bold = true },
  }

  local authorColors = { ['*'] = get_color({ fg = 'Constant' })[1] }
  local yaml_content = generate_yaml_content(theme, authorColors)
  local theme_path = vim.fn.stdpath 'cache' .. '/lazygit-theme.yml'
  local file = io.open(theme_path, 'w')
  if file then
    file:write(yaml_content)
    file:close()
    vim.notify('LazyGit theme updated!', vim.log.levels.INFO)
  else
    vim.notify('Could not write lazygit-theme.yml', vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.defer_fn(M.generate_lazygit_theme, 100)
  end,
})

return M
