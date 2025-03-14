-- Use nvim 0.9+ new loader with byte-compilation cache
-- https://neovim.io/doc/user/lua.html#vim.loader
if vim.loader then
  vim.loader.enable()
end
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath 'data' .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd 'echo "Installing `mini.nvim`" | redraw'
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd 'packadd mini.nvim | helptags ALL'
  vim.cmd 'echo "Installed `mini.nvim`" | redraw'
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup { path = { package = path_package } }

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

local function other_plugins()
  add {
    source = 'dstein64/vim-startuptime',
  }
  add {
    source = 'aserowy/tmux.nvim',
  }
  require('tmux').setup()
end

-- MiniDeps now and later functions to execute code safely
now(function()
  -- add {
  --   source = 'zenbones-theme/zenbones.nvim',
  --   depends = { 'rktjmp/lush.nvim' },
  -- }
  -- vim.cmd.colorscheme 'zenbones'
  vim.cmd.colorscheme 'base16'

  require 'config.options'
  require 'config.keymaps'
  require 'config.autocmds'
  require 'config.utils'

  -- Use 'mini.misc' for some useful helpers
  require('mini.misc').setup()
  MiniMisc.setup_restore_cursor()
  MiniMisc.setup_auto_root()
  MiniMisc.setup_termbg_sync()
  require('mini.basics').setup {
    options = { basic = true },
    mappings = { option_toggle_prefix = [[\]], move_with_alt = true },
    autocommands = { relnum_in_visual_mode = true },
    silent = true,
  }
  -- these should be now() for start-up screen
  require 'plugins.mini.statusline'
  require 'plugins.mini.sessions'
  require 'plugins.mini.tabline'
  require 'plugins.mini.starter'
  require 'plugins.mini.clue'
end)

later(function()
  require 'plugins.mini'
  require 'plugins.treesitter'
  require 'plugins.ts-autotag'
  require 'plugins.lspconfig'
  require 'plugins.avante'
  require 'plugins.typescript-tools'
  require 'plugins.colorizer'
  require 'plugins.obsidian'
  require 'plugins.render-markdown'
  require 'plugins.formatting'
  require 'plugins.linting'
  require 'plugins.completion'
  require 'plugins.neogen'
  require 'plugins.debugprint'
  require 'plugins.rest'
  require 'plugins.quicker'
  require 'plugins.grug-far'
  require 'plugins.ai-assistant'
  require 'plugins.toggleterm'
  require 'plugins.overseer'
  require 'plugins.refactoring'
  require 'plugins.ufo'
  require 'plugins.trouble'
  require 'plugins.zen-mode'
  require 'plugins.dadbod'
  -- require 'plugins.debug'
  -- require 'plugins.neotest'
  other_plugins()
end)
