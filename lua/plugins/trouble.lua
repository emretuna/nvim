local add = MiniDeps.add
add {
  source = 'folke/trouble.nvim',
}
---@diagnostic disable: missing-fields
require('trouble').setup {
  skip_groups = true,
  win = {
    border = vim.g.border_style,
  },
}

vim.keymap.set('n', '<leader>x.', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Trouble Toggle' })
vim.keymap.set('n', '<leader>x/', '<cmd>Trouble loclist toggle<cr>', { desc = 'Trouble Location List' })
vim.keymap.set('n', '<leader>xb', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Trouble Bbuffer Diagnostics' })
vim.keymap.set('n', '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Trouble Symbols' })
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'Trouble LSP Definitions/References/... ' })
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>', { desc = 'Trouble Quickfix List' })
