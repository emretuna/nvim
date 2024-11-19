return {
  'nvim-focus/focus.nvim',
  event = 'VeryLazy',
  version = '*',
  opts = {
    enable = true,
    autoresize = {
      enable = true,
    },
  },
  config = function(_, opts)
    require('focus').setup(opts)
    vim.keymap.set('n', '<leader>mo', '<cmd>FocusToggle<cr>', { desc = 'Toggle Focus Mode' })
  end,
}
