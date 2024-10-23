return {
  'nvim-focus/focus.nvim',
  event = 'VeryLazy',
  version = '*',
  opts = {
    enable = true,
    autoresize = {
      enable = true,
    },
    ui = {
      number = true, -- Display line numbers in the focussed window only
      relativenumber = true, -- Display relative line numbers in the focussed window only
      hybridnumber = true, -- Display hybrid line numbers in the focussed window only
    },
  },
  config = function(_, opts)
    require('focus').setup(opts)
    vim.keymap.set('n', '<leader>mo', '<cmd>FocusToggle<cr>', { desc = 'Toggle Focus Mode' })
  end,
}
