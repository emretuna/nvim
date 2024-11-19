-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Basic keymap shortcuts
vim.keymap.set('n', '<C-s>', '<cmd>w<cr>', { desc = 'Save file' })

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
vim.keymap.set('n', ']t', '<cmd>tabnext<cr>', { desc = 'Tab next' })
vim.keymap.set('n', '[t', '<cmd>tabprevious<cr>', { desc = 'Tab previous' })
-- buffers
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Buffer next' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Buffer previous' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch Buffer' })
vim.keymap.set('n', '<leader>ba', '<cmd>new<cr>', { desc = 'Buffer Add' })
-- better indent
vim.keymap.set('x', '<Tab>', '>gv', { desc = 'Indent Line' })
vim.keymap.set('x', '<S-Tab>', '<gv', { desc = 'Unindent Line' })

-- Toggle spell checking
vim.keymap.set('n', '<leader>mS', function()
  vim.opt.spell = not vim.o.spell
  print('Spell checking is', (vim.o.spell and 'enabled' or 'disabled'))
end, { desc = 'Spellcheck Toggle' })

-- terminal mappings

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Exit Terminal Mode' })
vim.keymap.set('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to Left Window' })
vim.keymap.set('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to Lower Window' })
vim.keymap.set('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to Upper Window' })
vim.keymap.set('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to Right Window' })
vim.keymap.set('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
-- Open terminal and run tree command
vim.api.nvim_set_keymap('n', '<leader>mT', ':3vsplit | terminal tree<CR>', { desc = 'Open Tree', noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>mO', ':3split | terminal tokei<CR>', { desc = 'Open Tokei', noremap = true, silent = true })
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- q to escape window types
vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Make q close help, man, quickfix, dap floats',
  callback = function(args)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
    if vim.tbl_contains({ 'help', 'nofile', 'quickfix' }, buftype) then
      vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = args.buf, silent = true, nowait = true })
    end
  end,
})
vim.api.nvim_create_autocmd('CmdwinEnter', {
  desc = 'Make q close command history (q: and q?)',
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = args.buf, silent = true, nowait = true })
  end,
})

-- vim: ts=2 sts=2 sw=2 et
