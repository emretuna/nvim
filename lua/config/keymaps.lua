-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
vim.keymap.set('n', 'XX', ':q<CR>', { silent = true })

-- Saves modified documents, and then exits
vim.keymap.set('n', 'ZZ', ':xa<CR>', { silent = true })
-- Open netrw
vim.keymap.set('n', '<leader>e', '<cmd>Lexplore!<CR>', { silent = true, desc = 'Open netrw' }) -- Try Vex or Vex! to open in a split
-- Clear search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Shifted movement
vim.keymap.set('n', '<C-d>', function()
  vim.api.nvim_feedkeys('7j', 'n', true)
end, {
  desc = 'Fast move down',
})

vim.keymap.set('n', '<C-u>', function()
  vim.api.nvim_feedkeys('7k', 'n', true)
end, {
  desc = 'Fast move up',
})
vim.keymap.set('n', '<leader>mz', function()
  MiniMisc.zoom()
end, { desc = 'Zoom Buffer' })
-- Map ScrollWheelUp to Ctrl+B
vim.api.nvim_set_keymap('n', '<ScrollWheelUp>', '<C-B>', { noremap = true })
-- Map ScrollWheelDown to Ctrl+F
vim.api.nvim_set_keymap('n', '<ScrollWheelDown>', '<C-F>', { noremap = true })

-- increment/decrement numbers
vim.keymap.set('n', 'g+', '<C-a>', { desc = 'Increment number' })
vim.keymap.set('n', 'g-', '<C-x>', { desc = 'Decrement number' })

-- window management
vim.keymap.set('n', '<leader>w|', '<C-w>v', { desc = 'Split Vertically' })
vim.keymap.set('n', '<leader>w-', '<C-w>s', { desc = 'Split Horizontally' })
vim.keymap.set('n', '<leader>wx', '<cmd>close<CR>', { desc = 'Close Current Split' })
vim.keymap.set('n', '<leader>wq', '<cmd>qa<CR>', { desc = 'Quit Neowim ' })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })
-- tabs
vim.keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = 'Open new tab' }) -- open new tab
vim.keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'Close current tab' }) -- close current tab
vim.keymap.set('n', '<leader>tf', '<cmd>tabnew %<CR>', { desc = 'Open current buffer in new tab' }) --  move current buffer to new tab
--
-- Rename file using LSP
vim.keymap.set('n', '<leader>mR', '<cmd>WorkspaceRenameFile<CR>', { desc = 'Rename file' })

-- Open file under cursor
vim.keymap.set('n', '<leader>mo', function()
  local osType = os.getenv 'OS'
  local filepath = vim.fn.expand '<cfile>' -- Get the file under the cursor
  if vim.fn.filereadable(filepath) == 1 then
    if osType == 'Darwin' then
      vim.fn.jobstart({ 'open', filepath }, { detach = true })
    else
      vim.fn.jobstart({ 'xdg-open', filepath }, { detach = true })
    end
  else
    vim.notify('No readable file under cursor', vim.log.levels.ERROR)
  end
end, { desc = 'Open file under cursor with open' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch Buffer' })
vim.keymap.set('n', '<leader>ba', '<cmd>new<cr>', { desc = 'Buffer Add' })
-- better indent
vim.keymap.set('x', '<Tab>', '>gv', { desc = 'Indent Line' })
vim.keymap.set('x', '<S-Tab>', '<gv', { desc = 'Unindent Line' })

-- Move to window using the <ctrl> arrow keys
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to Left Window' })
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to Lower Window' })
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to Upper Window' })
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to Right Window' })

-- Quickfix list keybinds
vim.keymap.set('n', '<leader>qn', '<cmd>cnext<CR>', { desc = 'Go to next item in Quickfix list' })
vim.keymap.set('n', '<leader>qp', '<cmd>cprev<CR>', { desc = 'Go to previous item in Quickfix list' })
vim.keymap.set('n', '<leader>q.', '<cmd>copen<CR>', { desc = 'Open Quickfix List' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = 'Close Quickfix List' })
-- Toggle terminals
vim.keymap.set('n', '<F7>', '<cmd>HorizontalTerm<CR>', { desc = 'Toggle Horizontal Terminal' })
vim.keymap.set('n', '<C-\\>', '<cmd>FloatTerm<CR>', { desc = 'Toggle Floating Terminal' })
vim.keymap.set('t', '<C-\\>', function()
  -- Exit terminal mode and close the floating terminal
  vim.cmd [[<C-\><C-n>]] '<cmd>FloatTerm<CR>'
end, { desc = 'Toggle Floating Terminal' })
vim.keymap.set('n', '<leader>g.', '<cmd>LazyGit<CR>', { desc = 'Toggle LazyGit' })
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Exit Terminal Mode' })
-- vim: ts=2 sts=2 sw=2 et
