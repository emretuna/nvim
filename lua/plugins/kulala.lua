require('kulala').setup {
  default_view = 'headers_body',
}

vim.keymap.set('n', '<leader>h.', ":lua require('kulala').run()<CR>", { desc = 'Http Run' })
vim.keymap.set('n', '<leader>ht', ":lua require('kulala').toggle_view()<CR>", { desc = 'Http Toggle' })
vim.keymap.set('n', '<leader>hs', ":lua require('kulala').show_stats()<CR>", { desc = 'Show stats' })
vim.keymap.set('n', '<leader>hb', ":lua require('kulala').scratchpad()<CR>", { desc = 'Open scratchpad' })
vim.keymap.set('n', '<leader>hi', ":lua require('kulala').inspect()<CR>", { desc = 'inspect Request' })
vim.keymap.set('n', '<leader>hy', ":lua require('kulala').copy()<CR>", { desc = 'Copy as cURL' })
vim.keymap.set('n', '<leader>hY', ":lua require('kulala').from_curl()<CR>", { desc = 'Paste as cURL' })
vim.keymap.set('n', '<leader>hg', ":lua require('kulala').download_graphql_schema()<CR>", { desc = 'Download GraphQL schema' })
vim.keymap.set('n', '<leader>hp', ":lua require('kulala').jump_prev()<CR>", { desc = 'Jump to previous request' })
vim.keymap.set('n', '<leader>hn', ":lua require('kulala').jump_next()<CR>", { desc = 'Jump to  next request' })
vim.keymap.set('n', '<leader>hr', ":lua require('kulala').replay()<CR>", { desc = 'Replay last request' })
vim.keymap.set('n', '<leader>hq', ":lua require('kulala').close()<CR>", { desc = 'Close window' })
vim.filetype.add {
  extension = {
    ['http'] = 'http',
    ['rest'] = 'http',
  },
}
