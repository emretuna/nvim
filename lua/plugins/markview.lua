return {
  'OXY2DEV/markview.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  lazy = false,
  ft = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
  opts = {
    filetypes = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
    buf_ignore = {},
    max_length = 99999,
  },
  config = function(_, opts)
    require('markview').setup(opts)
    vim.keymap.set('n', '<leader>mm', '<cmd>:Markview<cr>', { desc = 'Markview Toggle' })
  end,
}
