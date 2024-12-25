-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Alternative way to save and exit in Normal mode.
-- NOTE: Adding `redraw` helps with `cmdheight=0` if buffer is not modified
vim.keymap.set('n', '<C-S>', '<Cmd>silent! update | redraw<CR>', { desc = 'Save' })
vim.keymap.set({ 'i', 'x' }, '<C-S>', '<Esc><Cmd>silent! update | redraw<CR>', { desc = 'Save and go to Normal mode' })

vim.keymap.set('n', '<leader>fe', '<Cmd>Lexplore!<CR>', { silent = true, desc = 'Open netrw on right side' }) -- Try Vex or Vex! to open in a split

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Shifted movement
vim.keymap.set('n', '<S-Down>', function()
  vim.api.nvim_feedkeys('7j', 'n', true)
end, {
  desc = 'Fast move down',
})

vim.keymap.set('n', '<S-Up>', function()
  vim.api.nvim_feedkeys('7k', 'n', true)
end, {
  desc = 'Fast move up',
})

-- Move by visible lines. Notes:
-- - Don't map in Operator-pending mode because it severely changes behavior:
--   like `dj` on non-wrapped line will not delete it.
-- - Condition on `v:count == 0` to allow easier use of relative line numbers.
vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Move only sideways in command mode. Using `silent = false` makes movements
-- to be immediately shown.
vim.keymap.set('c', '<M-h>', '<Left>', { silent = false, desc = 'Left' })
vim.keymap.set('c', '<M-l>', '<Right>', { silent = false, desc = 'Right' })

-- Don't `noremap` in insert mode to have these keybindings behave exactly
-- like arrows (crucial inside TelescopePrompt)
vim.keymap.set('i', '<M-h>', '<Left>', { noremap = false, desc = 'Left' })
vim.keymap.set('i', '<M-j>', '<Down>', { noremap = false, desc = 'Down' })
vim.keymap.set('i', '<M-k>', '<Up>', { noremap = false, desc = 'Up' })
vim.keymap.set('i', '<M-l>', '<Right>', { noremap = false, desc = 'Right' })

vim.keymap.set('t', '<M-h>', '<Left>', { desc = 'Left' })
vim.keymap.set('t', '<M-j>', '<Down>', { desc = 'Down' })
vim.keymap.set('t', '<M-k>', '<Up>', { desc = 'Up' })
vim.keymap.set('t', '<M-l>', '<Right>', { desc = 'Right' })

-- Copy/paste with system clipboard
vim.keymap.set({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('n', 'gp', '"+p', { desc = 'Paste from system clipboard' })
-- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
vim.keymap.set('x', 'gp', '"+P', { desc = 'Paste from system clipboard' })

-- Reselect latest changed, put, or yanked text
vim.keymap.set('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, replace_keycodes = false, desc = 'Visually select changed text' })

-- Search inside visually highlighted text. Use `silent = false` for it to
-- make effect immediately.
vim.keymap.set('x', 'g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })
vim.keymap.set('n', '<leader>uH', '<Cmd>let v:hlsearch = 1 - v:hlsearch | echo (v:hlsearch ? "  " : "no") . "hlsearch"<CR>',{desc = 'Toggle search highlight'})
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
-- vim.keymap.set('n', ']t', '<cmd>tabnext<cr>', { desc = 'Tab next' })
-- vim.keymap.set('n', '[t', '<cmd>tabprevious<cr>', { desc = 'Tab previous' })

-- buffers

-- vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Buffer next' })
-- vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Buffer previous' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch Buffer' })
vim.keymap.set('n', '<leader>ba', '<cmd>new<cr>', { desc = 'Buffer Add' })
-- better indent
vim.keymap.set('x', '<Tab>', '>gv', { desc = 'Indent Line' })
vim.keymap.set('x', '<S-Tab>', '<gv', { desc = 'Unindent Line' })
-- toggles

vim.keymap.set('n', '<leader>ui', '<Cmd>setlocal ignorecase! ignorecase?<CR>', { desc = "Toggle ignorecase" })
vim.keymap.set('n', '<leader>uL', '<Cmd>setlocal list! list?<CR>', { desc = "Toggle list" })
vim.keymap.set('n', '<leader>uN', '<Cmd>setlocal number! number?<CR>', { desc = "Toggle number" })

--git tui
-- vim.keymap.set('n', '<leader>g.', function()
--   local git_dir = vim.fn.finddir('.git', vim.fn.getcwd() .. ';')
--   if git_dir ~= '' then
--     if vim.fn.executable 'keychain' == 1 then
--       vim.cmd 'TermExec cmd="eval `keychain --eval ~/.ssh/github.key` && lazygit && exit"'
--     else
--       vim.cmd "TermExec cmd='lazygit && exit'"
--     end
--   else
--     vim.notify('Not a git repository', vim.log.levels.WARN)
--   end
-- end, { desc = 'Lazygit' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Exit Terminal Mode' })
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to Left Window' })
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to Lower Window' })
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to Upper Window' })
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to Right Window' })
vim.keymap.set('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })

-- Quickfix list keybinds
vim.keymap.set('n', '<leader>qn', '<Cmd>cnext<CR>', { desc = 'Go to next item in Quickfix list' })
vim.keymap.set('n', '<leader>qp', '<Cmd>cprev<CR>', { desc = 'Go to previous item in Quickfix list' })
vim.keymap.set('n', '<leader>qo', '<Cmd>copen<CR>', { desc = 'Open Quickfix List' })
vim.keymap.set('n', '<leader>qc', '<Cmd>cclose<CR>', { desc = 'Close Quickfix List' })

-- vim: ts=2 sts=2 sw=2 et
