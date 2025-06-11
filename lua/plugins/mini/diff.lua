require('mini.diff').setup {
  view = {
    style = 'sign',
    signs = { add = '+', change = '~', delete = '-' },
  },
}
vim.keymap.set('n', '<leader>go', '<cmd>lua MiniDiff.toggle_overlay()<CR>', { desc = 'Open Diff View' })
