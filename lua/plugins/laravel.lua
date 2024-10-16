return {
  'adalessa/laravel.nvim',
  dependencies = {
    'tpope/vim-dotenv',
    'MunifTanjim/nui.nvim',
    'kevinhwang91/promise-async',
  },
  cmd = { 'Laravel' },
  keys = {
    { '<leader>ma', ':Laravel artisan<cr>', desc = 'Laravel artisan' },
    { '<leader>mr', ':Laravel routes<cr>', desc = 'Laravel routes' },
    { '<leader>mm', ':Laravel related<cr>', desc = 'Laravel related' },
  },
  opts = {},
  config = true,
}
