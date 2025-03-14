require('mini.git').setup()
vim.keymap.set({ 'n', 'x' }, '<Leader>gs', '<CMD>lua MiniGit.show_at_cursor()<CR>', { desc = 'Show at cursor' })
vim.keymap.set({ 'n', 'x' }, '<Leader>gd', '<CMD>lua MiniGit.show_diff_source()<CR>', { desc = 'Show diff source' })
vim.keymap.set({ 'n', 'x' }, '<Leader>gh', '<CMD>lua MiniGit.show_range_history()<CR>', { desc = 'Show range history' })
