-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- Don't show columns in these filetypes
local function augroup(name)
  return vim.api.nvim_create_augroup('vimrc_' .. name, { clear = true })
end

-- vim.api.nvim_create_autocmd({ 'FocusLost', 'ModeChanged', 'TextChanged', 'BufEnter' }, {
--   desc = 'Autosave',
--   pattern = '*',
--   command = 'silent! update | redraw',
-- })
-- macro function of mini.statusline
vim.api.nvim_create_autocmd('RecordingEnter', {
  pattern = '*',
  callback = function()
    vim.cmd 'redrawstatus'
  end,
})

-- Autocmd to track the end of macro recording
vim.api.nvim_create_autocmd('RecordingLeave', {
  pattern = '*',
  callback = function()
    vim.cmd 'redrawstatus'
  end,
})
-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup 'auto_create_dir',
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match

    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    local backup = vim.fn.fnamemodify(file, ':p:~:h')
    backup = backup:gsub('[/\\]', '%%')
    vim.go.backupext = backup
  end,
})

vim.api.nvim_create_autocmd('CursorMoved', {
  pattern = '*',
  group = augroup 'ResizeBuffer',
  desc = 'Resize buffer on entry, Alternative to focus.nvim',
  callback = function()
    local excluded_filetypes = {
      'neo-tree',
      'Trouble',
      'trouble',
      'netrw',
    }
    -- This handles all floating windows
    local win = vim.api.nvim_win_get_config(0)
    if win.relative ~= '' then
      return
    end
    if not vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
      vim.cmd('vertical resize ' .. math.floor(vim.o.columns / 1.618))
    end
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  callback = function()
    vim.cmd [[Trouble qflist open]]
  end,
})

-- Autocmd to track macro recording, And redraw statusline, which trigger
-- macro function of mini.statusline
vim.api.nvim_create_autocmd('RecordingEnter', {
  pattern = '*',
  callback = function()
    vim.g.macro_recording = 'Recording @' .. vim.fn.reg_recording()
    vim.cmd 'redrawstatus'
  end,
})

-- Autocmd to track the end of macro recording
vim.api.nvim_create_autocmd('RecordingLeave', {
  pattern = '*',
  callback = function()
    vim.g.macro_recording = ''
    vim.cmd 'redrawstatus'
  end,
})

-- Open help|man window in a vertical split to the right.
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = augroup 'help_window_right',
  pattern = { '*' },
  callback = function()
    if vim.bo.filetype == 'help' or vim.bo.filetype == 'man' then
      vim.cmd [[
        wincmd L
        vertical resize 90
      ]]
    end
  end,
})
vim.api.nvim_create_autocmd('filetype', {
  desc = 'Disable cursorcolumn and colorcolumn in these filetypes',
  pattern = { 'netrw', 'qf', 'help', 'oil', 'avante' },
  callback = function()
    vim.opt_local.colorcolumn = ''
    vim.opt_local.cursorcolumn = false
  end,
})

-- Highlight text on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = augroup 'highlight_yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'clear the last used search pattern',
  pattern = '*',
  callback = function()
    vim.fn.setreg('/', '') -- Clears the search register
    vim.cmd 'let @/ = ""' -- Clear the search register using Vim command
  end,
})

-- Show relative line numbers in Visual mode
vim.api.nvim_create_autocmd('ModeChanged', {
  desc = 'Show relative line numbers in Visual mode',
  group = augroup 'relative_line_numbers',
  pattern = '*:[V\x16]*',
  callback = function()
    if vim.wo.number then -- Avoid horizontal flickering
      vim.wo.relativenumber = true
    end
  end,
})

-- Hide relative line numbers outside Visual mode
vim.api.nvim_create_autocmd('ModeChanged', {
  desc = 'Hide relative line numbers outside Visual mode',
  group = augroup 'relative_line_numbers',
  pattern = '[V\x16]*:*',
  callback = function()
    vim.wo.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  desc = 'Close some filetypes with <q>',
  pattern = {
    'Avante',
    'AvanteInput',
    'PlenaryTestPopup',
    'checkhealth',
    'fugitive*',
    'git',
    'dap-repl',
    'help',
    'lspinfo',
    'man',
    'UndoTree',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'netrw',
    'notify',
    'noice',
    'query',
    'qf',
    'spectre_panel',
    'startuptime',
    'Trouble',
    'trouble',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close!<cr>', { buffer = event.buf, silent = true })
  end,
  group = augroup 'close_with_q',
})
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Disable right contextual menu warning message',
  callback = function()
    -- Disable right click message
    vim.api.nvim_command [[aunmenu PopUp.How-to\ disable\ mouse]]
    -- vim.api.nvim_command [[aunmenu PopUp.-1-]] -- You can remode a separator like this.
    vim.api.nvim_command [[menu PopUp.Toggle\ \Breakpoint <cmd>:lua require('dap').toggle_breakpoint()<CR>]]
    vim.api.nvim_command [[menu PopUp.-2- <Nop>]]
    vim.api.nvim_command [[menu PopUp.Start\ \Debugger <cmd>:DapContinue<CR>]]
    vim.api.nvim_command [[menu PopUp.Run\ \Test <cmd>:Neotest run<CR>]]
  end,
})
