return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    enabled = false,
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      ---@type false | "classic" | "modern" | "helix"
      preset = 'helix',
      win = { border = vim.g.border_style },
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = false,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>a', group = 'AI', mode = { 'n', 'x' } },
        { '<leader>b', group = 'Buffers' },
        { '<leader>f', group = 'Find' },
        { '<leader>g', group = 'Git' },
        { '<leader>h', group = 'Http' },
        { '<leader>l', group = 'Lsp' },
        { '<leader>n', group = 'Notes' },
        { '<leader>o', group = 'Overseer' },
        { '<leader>q', group = 'Qucikfix' },
        { '<leader>r', group = 'Refactor' },
        { '<leader>s', group = 'Search' },
        { '<leader>t', group = 'Tabs' },
        { '<leader>m', group = 'Misc' },
        { '<leader>u', group = 'UI' },
        { '<leader>v', group = 'Visits' },
        { '<leader>w', group = 'Window' },
        { '<leader>x', group = 'Trouble' },
        { '<leader><leader>', group = 'Smart Splits' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
