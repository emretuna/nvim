require('mini.visits').setup()
vim.keymap.set('n', '<leader>va', function()
  MiniVisits.add_label()
end, { desc = 'Add Visit' })
vim.keymap.set('n', '<leader>vd', function()
  MiniVisits.remove_label()
end, { desc = 'Delete Visit' })

return {}
