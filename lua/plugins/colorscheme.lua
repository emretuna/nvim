return {
  {
    'echasnovski/mini.base16',
    config = function()
      require('mini.base16').setup {
        palette = {
          base00 = '#0a0a0a', -- Darkest background
          base01 = '#080808', -- Slightly lighter
          base02 = '#191919', -- Mid dark
          base03 = '#2a2a2a', -- Comments
          base04 = '#444444', -- Lighter midtone
          base05 = '#555555', -- Default text
          base06 = '#7a7a7a', -- Slightly lighter text
          base07 = '#AAAAAA', -- Lightest text
          base08 = '#b98d7b', -- Subtle accents
          base09 = '#789978', -- Another variation for highlights
          base0A = '#505050', -- Alternate text
          base0B = '#deeeed', -- Lighter accents
          base0C = '#DDDDDD', -- Alternate muted accent
          base0D = '#708090', -- UI elements
          base0E = '#383838', -- Subdued highlights
          base0F = '#202020', -- Accent for strong elements
        },
        use_cterm = true,
      }
    end,
  },
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:FzfLua colorschemes`.
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    enabled = false,
    init = function()
      vim.cmd 'colorscheme tokyonight'
    end,
  },
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
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    enabled = false,
    opts = {
      -- Enable transparent background
      transparent = true,
      -- Enable italics comments
      italic_comments = true,
      -- Replace all fillchars with ' ' for the ultimate clean look
      hide_fillchars = true,
      -- Modern borderless telescope theme - also applies to fzf-lua
      borderless_telescope = false,
      -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
      cache = true,
      theme = {
        variant = 'default',
      },
    },
    init = function()
      vim.cmd 'colorscheme cyberdream'
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
  {
    'aktersnurra/no-clown-fiesta.nvim',
    lazy = false,
    priority = 1000,
    enabled = false,
    opts = {
      -- transparent = true,
      styles = {
        comments = {
          italic = true,
        },
      },
    },
    init = function()
      vim.cmd.colorscheme 'no-clown-fiesta'
    end,
  },
}
