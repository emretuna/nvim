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

-- Safely execute immediately

local function mini()
  require 'plugins.mini.ai'
  require 'plugins.mini.align'
  require 'plugins.mini.animate'
  require 'plugins.mini.bufremove'
  require 'plugins.mini.clue'
  require 'plugins.mini.files'
  require 'plugins.mini.git'
  require 'plugins.mini.hipatterns'
  require 'plugins.mini.icons'
  require 'plugins.mini.indentscope'
  require 'plugins.mini.notify'
  require 'plugins.mini.pairs'
  require 'plugins.mini.pick'
  require 'plugins.mini.sessions'
  require 'plugins.mini.starter'
  require 'plugins.mini.statusline'
  require 'plugins.mini.tabline'
  require 'plugins.mini.visits'
  require('mini.jump').setup()
  require('mini.jump2d').setup()
  require('mini.misc').setup()
  require('mini.misc').setup_restore_cursor()
  require('mini.misc').setup_auto_root()
  require('mini.misc').setup_termbg_sync()
  require('mini.bracketed').setup()

  require('mini.splitjoin').setup {
    mappings = {
      toggle = 'gS',
    },
  }

  require('mini.extra').setup()
  require('mini.surround').setup()
  require('mini.move').setup()
  require('mini.diff').setup { view = {
    style = 'sign',
    signs = { add = '+', change = '~', delete = '-' },
  } }
end
local function treesitter()
  add {
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    depends = {
      'folke/ts-comments.nvim',
      'windwp/nvim-ts-autotag',
    },
    -- Perform action after every checkout
    hooks = {
      post_checkout = function()
        vim.cmd 'TSUpdate'
      end,
    },
  }
  require 'plugins.treesitter'
  require 'plugins.ts-autotag'
end
local function lsp()
  add {
    source = 'neovim/nvim-lspconfig',
    -- Supply dependencies near target plugin
    depends = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'b0o/schemastore.nvim',
      'folke/lazydev.nvim',
    },
  }

  require 'plugins.lspconfig'
  vim.cmd 'LspStart'
end
local function completion()
  add {
    source = 'Saghen/blink.cmp',
    checkout = 'v0.11.0',
    depends = {
      'rafamadriz/friendly-snippets',
    },
  }
  require 'plugins.blink'
end

local function typescript()
  add {
    source = 'pmizio/typescript-tools.nvim',
    depends = {
      'nvim-lua/plenary.nvim',
      'dmmulroy/ts-error-translator.nvim',
    },
  }
  require 'plugins.typescript-tools'
  require('ts-error-translator').setup {
    auto_override_publish_diagnostics = true,
  }
end

local function ai()
  add {
    source = 'yetone/avante.nvim',
    monitor = 'main',
    depends = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'echasnovski/mini.icons', -- or echasnovski/mini.icons
      -- 'zbirenbaum/copilot.lua', -- for providers='copilot'
      'HakonHarnes/img-clip.nvim',
    },
    hooks = {
      post_checkout = function()
        vim.cmd 'AvanteBuild'
      end,
    },
  }
  require 'plugins.avante'
  vim.keymap.set('n', '<leader>mp', function()
    require('avante.clipboard').paste_image()
  end, {
    desc = 'Paste Image',
  })
  -- Use neocodeium or supermaven for autocompletion
  add {
    source = 'monkoose/neocodeium',
  }
  require('neocodeium').setup {
    manual = false,
    show_label = true,
    silent = true,
    debounce = false,
  }
  local neocodeium = require 'neocodeium'
  require('neocodeium').setup()
  vim.keymap.set('i', '<c-y>', function()
    neocodeium.accept()
  end)
  vim.keymap.set('i', '<c-w>', function()
    neocodeium.accept_word()
  end)
  vim.keymap.set('i', '<c-e>', function()
    neocodeium.accept_line()
  end)
  vim.keymap.set('i', '<c-p>', function()
    neocodeium.cycle_or_complete(-1)
  end)
  vim.keymap.set('i', '<c-n>', function()
    neocodeium.cycle_or_complete()
  end)

  -- add {
  --   source = 'supermaven-inc/supermaven-nvim',
  -- }
  -- require('supermaven-nvim').setup {
  --   keymaps = {
  --     accept_suggestion = '<C-y>',
  --     accept_word = '<C-w>',
  --   },
  --   log_level = 'off',
  --   color = {
  --     suggestion_color = '#a6a69c',
  --   },
  -- }
end
local function formatting()
  add {
    source = 'stevearc/conform.nvim',
  }
  require 'plugins.formatting'

  add {
    source = 'mfussenegger/nvim-lint',
  }
  require 'plugins.linting'
end
local function debugging()
  add {
    source = 'mfussenegger/nvim-dap',
    depends = {
      'rcarriga/nvim-dap-ui',
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'nvim-neotest/nvim-nio',
      -- "leoluz/nvim-dap-go",
      -- "mfussenegger/nvim-dap-python",
    },
  }
  require 'plugins.debug'
end
local function sql()
  add {
    source = 'tpope/vim-dadbod',
    depends = {
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
  }
end

local function rest()
  add {
    source = 'mistweaverco/kulala.nvim',
  }
  require 'plugins.kulala'
end

local function search()
  add {
    source = 'MagicDuck/grug-far.nvim',
  }
  require('grug-far').setup()
  vim.keymap.set('n', '<leader>ff', '<cmd>:GrugFar<cr>', { desc = 'Search Replate' })
end

local function debugprint()
  add {
    source = 'andrewferrier/debugprint.nvim',
  }
  require('debugprint').setup()
end

local function neogen()
  add {
    source = 'danymat/neogen',
  }
  require('neogen').setup {}
  vim.keymap.set('n', 'g@', ':lua require("neogen").generate()<CR>', { desc = 'Neogen Generate Annotations' })
end

local function quickfix()
  add {
    source = 'stevearc/quicker.nvim',
  }
  local quicker = require 'quicker'
  quicker.setup()

  vim.keymap.set('n', '<leader>qq', function()
    quicker.toggle()
  end, {
    desc = 'Toggle quickfix',
  })
  vim.keymap.set('n', '<leader>ql', function()
    quicker.toggle { loclist = true }
  end, {
    desc = 'Toggle loclist',
  })
  vim.keymap.set('n', '>', function()
    quicker.expand { before = 2, after = 2, add_to_existing = true }
  end, {
    desc = 'Expand quickfix context',
  })
  vim.keymap.set('n', '<', function()
    quicker.collapse()
  end, {
    desc = 'Collapse quickfix context',
  })
end
local function trouble()
  add {
    source = 'folke/trouble.nvim',
  }
  ---@diagnostic disable: missing-fields
  require('trouble').setup {
    skip_groups = true,
    win = {
      border = vim.g.border_style,
    },
  }

  vim.keymap.set('n', '<leader>x.', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Trouble Toggle' })
  vim.keymap.set('n', '<leader>x/', '<cmd>Trouble loclist toggle<cr>', { desc = 'Trouble Location List' })
  vim.keymap.set('n', '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Trouble Bbuffer Diagnostics' })
  vim.keymap.set('n', '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Trouble Symbols' })
  vim.keymap.set('n', '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'Trouble LSP Definitions/References/... ' })
  vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Trouble Quickfix List' })
end
local function markdown()
  add {
    source = 'MeanderingProgrammer/render-markdown.nvim',
    depends = { 'nvim-treesitter/nvim-treesitter' },
  }
  add {
    source = 'epwalsh/obsidian.nvim',
  }

  require 'plugins.render-markdown'
  require 'plugins.obsidian'
end
local function colorizer()
  add {
    source = 'NvChad/nvim-colorizer.lua',
  }
  require('colorizer').setup {
    filetypes = {
      'css',
      'scss',
      'html',
      'javascript',
      'typescript',
      'typescriptreact',
      'lua',
      'json',
      cmp_docs = {
        always_update = true,
      },
      cmp_menu = {
        always_update = true,
      },
    },
    user_default_options = {
      -- Available modes for `mode`: foreground, background,  virtualtext
      mode = 'virtualtext',
      css = true,
      css_fn = true,
      tailwind = true,
      virtualtext = ' ',
    },
  }
end

local function misc()
  add {
    source = 'akinsho/toggleterm.nvim',
  }
  add {
    source = 'stevearc/overseer.nvim',
  }
  add {
    source = 'ThePrimeagen/refactoring.nvim',
    depends = { 'nvim-lua/plenary.nvim' },
  }
  add {
    source = 'mrjones2014/smart-splits.nvim',
  }
  add {
    source = 'kevinhwang91/nvim-ufo',
    depends = {
      'kevinhwang91/promise-async',
    },
  }
  add {
    source = 'folke/zen-mode.nvim',
    depends = {
      'folke/twilight.nvim',
    },
  }
  add {
    source = 'dstein64/vim-startuptime',
  }
  require 'plugins.toggleterm'
  require 'plugins.overseer'
  require 'plugins.refactoring'
  require 'plugins.smart-splits'
  require 'plugins.ufo'
  require 'plugins.zen-mode'
end

-- MiniDeps now and later functions to execute code safely
now(function()
  add {
    source = 'zenbones-theme/zenbones.nvim',
    depends = { 'rktjmp/lush.nvim' },
  }
  vim.cmd.colorscheme 'zenbones'

  require 'config.options'
  require 'config.keymaps'
  require 'config.autocmds'
  require 'config.utils'

  mini()
end)

later(function()
  completion()
  treesitter()
  lsp()
  typescript()
  ai()
  formatting()
  -- debugging()
  -- sql()
  debugprint()
  rest()
  search()
  quickfix()
  trouble()
  markdown()
  neogen()
  colorizer()
  misc()
end)
