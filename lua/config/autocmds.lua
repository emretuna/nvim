-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- Don't show columns in these filetypes
local function augroup(name)
  return vim.api.nvim_create_augroup('vimrc_' .. name, { clear = true })
end

-- Autosave changed files
-- vim.api.nvim_create_autocmd({ 'FocusLost', 'ModeChanged', 'TextChanged', 'BufEnter' }, {
--   desc = 'Autosave',
--   pattern = '*',
--   command = 'silent! update | redraw',
-- })

vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  callback = function()
    vim.cmd 'checktime'
  end,
})

-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = '*',
  group = augroup 'auto_create_dir',
  callback = function(event)
    if event.match:match '^%w%w+:[\\/][\\/]' then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'wrap_spell',
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method 'textDocument/foldingRange' then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end
  end,
})
-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup 'json_conceal',
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'man_unlisted',
  pattern = { 'man' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
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

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'clear the last used search pattern',
  pattern = '*',
  callback = function()
    vim.fn.setreg('/', '') -- Clears the search register
    vim.cmd 'let @/ = ""' -- Clear the search register using Vim command
  end,
})

-- temporary solution for claude.nvim
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*claude*',
  callback = function()
    vim.bo.filetype = 'claude_term'
    vim.bo.bufhidden = 'hide'
  end,
})

-- Close some filetypes with <q>
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
    'Oil',
    'grug-far',
    'snacks_terminal',
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
