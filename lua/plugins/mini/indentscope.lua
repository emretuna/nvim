require('mini.indentscope').setup {
  symbol = '╎', --  ╎ │
  options = { try_as_border = true },
}
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'Trouble',
    'alpha',
    'avante',
    'dashboard',
    'fzf',
    'help',
    'lazy',
    'lspinfo',
    'man',
    'mason',
    'minifiles',
    'neo-tree',
    'nofile',
    'notify',
    'noice',
    'netrw',
    'oil',
    'oil_preview',
    'toggleterm',
    'trouble',
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})
return {}
