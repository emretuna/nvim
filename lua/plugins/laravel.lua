local add = MiniDeps.add

add {
  source = 'adalessa/laravel.nvim',
  depends = {
    'tpope/vim-dotenv',
    'MunifTanjim/nui.nvim',
    'kevinhwang91/promise-async',
  },
}
require('laravel-nvim').setup {
  keys = {
    { '<leader>mA', ':Laravel artisan<cr>' },
    { '<leader>mR', ':Laravel routes<cr>' },
    { '<leader>mM', ':Laravel related<cr>' },
  },
}
