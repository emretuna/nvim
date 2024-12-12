return {
  {
    'echasnovski/mini.base16',
    config = function()
      require('mini.base16').setup {
        palette = {
          base00 = '#0a0a0a', -- Darkest background
          base01 = '#121212', -- Slightly lighter for subtle contrast
          base02 = '#1e1e1e', -- Mid dark for UI elements
          base03 = '#2a2a2a', -- Comments and subtle text
          base04 = '#3c3c3c', -- Midtone for inactive elements
          base05 = '#5a5a5a', -- Default text, standard readability
          base06 = '#8a8a8a', -- Slightly lighter text for emphasis
          base07 = '#c4c4c4', -- Lightest text, headings
          base08 = '#a0756e', -- Variables, markup link text (softer orange-brown)
          base09 = '#789978', -- Integers, booleans, constants (muted green)
          base0A = '#4a4a4a', -- Classes, markup bold (dark gray)
          base0B = '#b9c9c9', -- Strings, markup code (pale blue-gray for clarity)
          base0C = '#9a9a9a', -- Support, diff changed (neutral gray)
          base0D = '#708090', -- Functions, methods (cool gray-blue)
          base0E = '#3e3e3e', -- Keywords, storage (subtle highlight)
          base0F = '#252525', -- Deprecated, special tags (dark and subdued)
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
