return {
  'adalessa/laravel.nvim',
  dependencies = {
    'tpope/vim-dotenv',
    'MunifTanjim/nui.nvim',
    'kevinhwang91/promise-async',
  },
  ft = { 'php', 'blade' },
  event = 'VeryLazy',
  cmd = { 'Laravel' },
  opts = {},
  config = function()
    require('laravel').setup()
    vim.keymap.set('n', '<leader>mA', ':Laravel artisan<cr>', { desc = 'Laravel artisan' })
    vim.keymap.set('n', '<leader>mR', ':Laravel routes<cr>', { desc = 'Laravel routes' })
    vim.keymap.set('n', '<leader>mM', ':Laravel related<cr>', { desc = 'Laravel related' })
  end,
}
