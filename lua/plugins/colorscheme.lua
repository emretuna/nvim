return {
  -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:FzfLua colorschemes`.

  {
    'ramojus/mellifluous.nvim',
    lazy = false,
    priority = 1000,
    enabled = false,
    opts = {
      flat_background = { line_numbers = true, floating_windows = true },
      colorset = 'kanagawa_dragon', -- 'kanagawa_dragon','melliflous','alduin','mountain','tender'
      transparent_background = {
        enabled = false,
      },
      dim_inactive = false,
    },
    config = function(_, opts)
      require('mellifluous').setup(opts)
      vim.cmd 'colorscheme mellifluous'
    end,
  },
  {
    'zenbones-theme/zenbones.nvim',
    -- Optionally install Lush. Allows for more configuration or extending the colorscheme
    -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
    -- In Vim, compat mode is turned on as Lush only works in Neovim.
    dependencies = { 'rktjmp/lush.nvim', event = 'VeryLazy', priority = 1000 },
    lazy = false,
    priority = 1000,
    -- enabled = false,
    -- you can set set configuration options here
    config = function()
      vim.cmd.colorscheme 'zenbones'
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    enabled = false,
    init = function()
      vim.cmd 'colorscheme tokyonight'
    end,
  },
  {
    'aktersnurra/no-clown-fiesta.nvim',
    lazy = false,
    priority = 1000,
    enabled = false,
    opts = {
      transparent = true,
      styles = {
        comments = {
          italic = true,
        },
      },
    },
    config = function(_, opts)
      require('no-clown-fiesta').setup(opts)
      vim.cmd 'colorscheme no-clown-fiesta'
    end,
  },
  {
    'slugbyte/lackluster.nvim',
    lazy = false,
    priority = 1000,
    enabled = false,
    opts = function()
      -- local lackluster = require 'lackluster'
      return {
        tweak_background = {
          -- ('default' is default) ('none' is transparent) ('#ffaaff' is a custom hexcode)
          normal = 'default', -- main background
          -- normal = 'none', -- transparent
          -- normal = '#a1b2c3',    -- hexcode
          -- normal = lackluster.color.lack, -- lackluster color
          menu = 'none', -- nvim_cmp, wildmenu ...
          popup = 'none', -- lazy, mason, whichkey ...
          telescope = 'none', -- telescope
        },
        tweak_highlight = {
          ['@comment'] = {
            italic = true,
          },
        },
      }
    end,
    init = function()
      -- vim.cmd.colorscheme 'lackluster'
      vim.cmd.colorscheme 'lackluster-hack'
      -- vim.cmd.colorscheme 'lackluster-mint'
    end,
  },
}
