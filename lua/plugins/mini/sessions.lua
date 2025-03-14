require('mini.sessions').setup {
  autoread = false,
  autowrite = true,
}
vim.keymap.set('n', '<leader>mS', ':lua MiniSessions.write(vim.fn.input("Session Name >"))<CR>', { desc = 'Save Session' })
