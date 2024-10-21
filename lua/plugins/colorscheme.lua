return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:FzfLua colorschemes`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    enabled = false,
  },
  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
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
    opts = {},
    -- init = function()
    --   -- vim.cmd.colorscheme("lackluster")
    --   vim.cmd.colorscheme 'lackluster-hack'
    --   -- vim.cmd.colorscheme("lackluster-mint")
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
  },
}
