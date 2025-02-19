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
    -- vim.notify('LazyGit theme updated!', vim.log.levels.INFO)
  else
    vim.notify('Could not write lazygit-theme.yml', vim.log.levels.ERROR)
  end
end
return M
