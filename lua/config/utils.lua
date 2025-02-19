local M = {}

function M.pluginNames()
  local function readFile(filepath)
    local file = io.open(filepath, 'r')
    if not file then
      print('Failed to open file:', filepath)
      return nil
    end
    local content = file:read '*a' -- Read the entire file content
    file:close()
    return content
  end

  local lazyLock = '~/.config/nvim/lazy-lock.json'
  local content = readFile(vim.fn.expand(lazyLock)) -- Expand the '~'
  if not content then
    print 'Failed to read file.'
    return
  end

  -- Lua json decoder needs some package from luarocks
  -- Decode JSON content to a Lua table using Neovim's json_decode
  local data = vim.fn.json_decode(content)
  if not data then
    print 'Failed to decode JSON.'
    return
  end

  local keys = {}
  for key, _ in pairs(data) do
    table.insert(keys, key)
  end

  return keys
end

function M.lazyPluginNames()
  local keys = {}
  for _, plugin in ipairs(require('lazy').plugins()) do
    table.insert(keys, plugin.name)
  end

  return keys
end

function M.reloadConfig()
  local config_path = vim.fn.stdpath 'config' .. '/lua/'
  for name, _ in pairs(package.loaded) do
    if name:match('^' .. config_path:match 'lua/(.*)$') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify('Nvim configuration reloaded!', vim.log.levels.INFO)
end

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

function M.generate_lazygit_theme()
  local current_theme = vim.g.colors_name or 'default'
  if vim.g.last_lazygit_theme == current_theme then
    return
  end
  vim.g.last_lazygit_theme = current_theme -- Store the new theme globally
  local theme = {
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

  local yaml_content = 'gui:\n  theme:\n'
  for key, value in pairs(theme) do
    yaml_content = yaml_content .. string.format('    %s:\n', key)
    for _, v in ipairs(value) do
      yaml_content = yaml_content .. string.format("      - '%s'\n", v)
    end
  end
  yaml_content = yaml_content .. "\n  authorColors:\n    '*': '" .. authorColors['*'] .. "'\n"

  local file = io.open(vim.fn.stdpath 'config' .. '/lazygit-theme.yml', 'w')
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
