return {
  'adalessa/laravel.nvim',
  enabled = vim.g.laravel_enabled,
  dependencies = {
    'tpope/vim-dotenv',
    'MunifTanjim/nui.nvim',
    'kevinhwang91/promise-async',
  },
  event = 'VeryLazy',
  ft = { 'php', 'blade' },
  cmd = { 'Laravel' },
  keys = {
    { '<leader>mA', ':Laravel artisan<cr>' },
    { '<leader>mR', ':Laravel routes<cr>' },
    { '<leader>mM', ':Laravel related<cr>' },
  },
  opts = {},
  config = true,
}
