local M = {}
-- Bigfile (https://github.com/folke/snacks.nvim/blob/e937bfaa741c4ac7379026b09ec252bd7a9409a6/lua/snacks/bigfile.lua#L19C1-L32C5)
local size = 1.5 * 1024 * 1024 -- 1.5MB

vim.filetype.add {
  pattern = {
    ['.*'] = {
      function(path, buf)
        return vim.bo[buf] and vim.bo[buf].filetype ~= 'bigfile' and path and vim.fn.getfsize(path) > size and 'bigfile' or nil
      end,
    },
  },
}

local function on_bigfile(ev)
  vim.b.minianimate_disable = true
  vim.schedule(function()
    vim.bo[ev.buf].syntax = ev.ft
  end)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ':p:~:.')
  vim.notify(('Big file detected `%s`.'):format(path))
end

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = vim.api.nvim_create_augroup('on_bigfile', { clear = true }),
  pattern = 'bigfile',
  callback = function(ev)
    vim.api.nvim_buf_call(ev.buf, function()
      on_bigfile {
        buf = ev.buf,
        ft = vim.filetype.match { buf = ev.buf } or '',
      }
    end)
  end,
})

local function get_color(v)
  ---@type string[]
  local color = {}
  for _, c in ipairs { 'fg', 'bg' } do
    if v[c] then
      local name = v[c]
      local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      local hl_color ---@type number?
      if c == 'fg' then
        hl_color = hl and hl.fg or hl.foreground
      else
        hl_color = hl and hl.bg or hl.background
      end
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

---@param theme table
---@param authorColors table
local function generate_yaml_content(theme, authorColors)
  local lines = {
    'gui:',
    '  nerdFontsVersion: "3"',
    '  theme:',
  }

  -- Add theme colors
  for key, value in pairs(theme) do
    table.insert(lines, string.format('    %s:', key))
    for _, v in ipairs(value) do
      table.insert(lines, string.format("      - '%s'", v))
    end
  end

  -- Add author colors
  table.insert(lines, '    authorColors:')
  table.insert(lines, string.format("      '*': '%s'", authorColors['*']))

  -- Add OS settings with proper nvim-remote configuration
  table.insert(lines, 'os:')
  table.insert(lines, "  editPreset: 'nvim-remote'")
  return table.concat(lines, '\n') .. '\n'
end

function M.generate_lazygit_theme()
  -- Get current colorscheme name, fallback to 'default' if not set
  local current_theme = vim.g.colors_name or 'default'

  -- Initialize last_lazygit_theme if it doesn't exist
  vim.g.last_lazygit_theme = vim.g.last_lazygit_theme or current_theme

  -- If no colorscheme change, do nothing
  if current_theme == vim.g.last_lazygit_theme then
    return
  end

  -- Store the new theme globally for future comparisons
  vim.g.last_lazygit_theme = current_theme

  -- Define theme colors
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

  -- Generate YAML content
  local yaml_content = generate_yaml_content(theme, authorColors)

  -- Write to file
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

local uv = vim.uv or vim.loop

---@param path string
local function realpath(path)
  return vim.fs.normalize(uv.fs_realpath(path) or path)
end

-- Prompt for the new filename,
-- do the rename, and trigger LSP handlers
---@param opts? {file?: string, on_rename?: fun(new:string, old:string)}
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

--- Lets LSP clients know that a file has been renamed
---@param from string
---@param to string
---@param rename? fun()
function M.on_rename_file(from, to, rename)
  local changes = { files = { {
    oldUri = vim.uri_from_fname(from),
    newUri = vim.uri_from_fname(to),
  } } }

  local clients = (vim.lsp.get_clients or vim.lsp.get_active_clients)()
  for _, client in ipairs(clients) do
    if client.supports_method 'workspace/willRenameFiles' then
      local resp = client.request_sync('workspace/willRenameFiles', changes, 1000, 0)
      if resp and resp.result ~= nil then
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

return M
