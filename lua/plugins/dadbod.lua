local add = MiniDeps.add
add {
  source = 'tpope/vim-dadbod',
  depends = {
    'kristijanhusak/vim-dadbod-ui',
    'kristijanhusak/vim-dadbod-completion',
  },
}

vim.g.db_ui_use_nerd_fonts = 1
vim.g.vim_dadbod_completion_mark = '󱘲'
