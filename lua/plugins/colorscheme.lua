return {
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
      -- vim.cmd 'colorscheme tokyonight'
    end,
  },
  {
    'aliqyan-21/darkvoid.nvim',
    lazy = false,
    priority = 1000,
    enabled = false,
    opts = {
      transparent = true, -- set true for transparent
      glow = true, -- set true for glow effect
      show_end_of_buffer = true, -- set false for not showing end of buffer
    },

    -- init = function()
    --   vim.cmd.colorscheme 'darkvoid'
    -- end,
  },
  {
    'zenbones-theme/zenbones.nvim',
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.zenbones_compat = true
      vim.cmd 'colorscheme zenbones'
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
    -- init = function()
    --   vim.cmd 'colorscheme cyberdream'
    -- end,
  },

  {
    'slugbyte/lackluster.nvim',
    lazy = false,
    priority = 1000,
    enabled = false,
    opts = {},
    init = function()
      -- vim.cmd.colorscheme 'lackluster'
      -- vim.cmd.colorscheme 'lackluster-hack'
      -- vim.cmd.colorscheme 'lackluster-mint'
    end,
  },
  {
    'aktersnurra/no-clown-fiesta.nvim',
    lazy = false,
    priority = 1000,
    enabled = false,
    opts = {
      transparent = true,
    },
    -- init = function()
    --   vim.cmd.colorscheme 'no-clown-fiesta'
    -- end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    enabled = false,
    opts = {
      --- @usage 'auto'|'main'|'moon'|'dawn'
      dark_variant = 'main',
      disable_italics = true,
    },
    -- init = function()
    --   vim.cmd.colorscheme 'rose-pine'
    -- end,
  },
}
