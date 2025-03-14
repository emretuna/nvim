require('mini.indentscope').setup {
  symbol = '╎', --  ╎ │
  options = { try_as_border = true },
  draw = {
    delay = 0,
    animation = require('mini.indentscope').gen_animation.quadratic { easing = 'out', duration = 750, unit = 'total' },
    priority = 2,
  },
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
