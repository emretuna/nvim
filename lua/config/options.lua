-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
--
-- vim.g.colorscheme = 'default'
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.cmdheight = 0 -- Hide command line spacing

-- Netrw settings
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 25
vim.g.netrw_altv = 1

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.g.db_ui_use_nerd_fonts = 1
vim.g.vim_dadbod_completion_mark = '󱘲'

vim.g.startuptime_tries = 10
-- Global variable to control borders for every plugins
vim.g.border_style = 'rounded'

vim.g.border = {
  { '╭', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╮', 'FloatBorder' },
  { '│', 'FloatBorder' },
  { '╯', 'FloatBorder' },
  { '─', 'FloatBorder' },
  { '╰', 'FloatBorder' },
  { '│', 'FloatBorder' },
}

-- Enable lsp rounded borders
vim.g.lsp_round_borders_enabled = true
-- Enable cmp rounded borders
vim.g.completion_round_borders_enabled = true

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true
vim.o.spell = false
vim.o.spelllang = 'en_us'
-- Disable some plugins to reduce startup time
vim.g.dap_enabled = false
vim.g.dadbod_enabled = false
vim.g.precognition_enabled = false
vim.g.neotest_enabled = false
vim.g.laravel_enabled = false
-- AI assistant configuration
-- Options: 'codeium' or 'supermaven'
vim.g.ai_assistant = 'codeium'
-- vim.o.pumblend = 10 -- Make builtin completion menus slightly transparent
-- vim.o.pumheight = 10 -- Make popup menu smaller
-- vim.o.winblend = 10 -- Make floating windows slightly transparent
-- Misc Settings
vim.opt.undofile = true -- Enable persistent undo between session and reboots.
vim.opt.backup = false -- Don't store backup while overwriting the file
vim.opt.writebackup = false -- Disable making a backup before overwriting a file.
vim.opt.mouse = 'a' -- Enable mouse mode, can be useful for resizing splits for example! To disable set it to " "

vim.opt.breakindent = true -- Enable break indent
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.opt.number = true -- Make line numbers default
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.ruler = false -- Don't show cursor position in command line
vim.opt.showmode = false -- Disable showing mode since we have a statusline
vim.opt.wrap = true -- Disable wrapping of lines longer than the width of window.
vim.opt.signcolumn = 'yes' -- Always show the sign column
vim.opt.fillchars = 'eob: ' -- Don't show `~` outside of buffer
vim.opt.ignorecase = true -- Case insensitive searching
vim.opt.incsearch = true -- Show search results while typing
vim.opt.infercase = true -- Infer letter cases for a richer built-in keyword completion
vim.opt.smartcase = true -- Case sensitive when using capital letters
vim.opt.smartindent = true -- Make indenting smart
vim.opt.completeopt = 'menuone,noinsert,noselect' -- Customize completions
vim.opt.virtualedit = 'block' -- Allow going past end of line in visual block mode.
vim.opt.formatoptions = 'qjl1' -- Don't have 'o' add a comment, From new tjdrevis video
vim.opt.termguicolors = true -- Enable 24-bit RGB color in the TUI.
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- vim.opt.relativenumber = true -- Make relative line numbers default

vim.opt.timeoutlen = 500 -- Shorten key timeout length a little bit for which-key.
vim.opt.updatetime = 300 -- Length of time to wait before triggering the plugin.

vim.opt.shada = "!,'1000,<50,s10,h" -- Remember the last 1000 opened files
vim.opt.undodir = vim.fn.stdpath 'data' .. '/undodir' -- Chooses where to store the undodir.
vim.opt.history = 1000 -- Number of commands to remember in a history table (per buffer).
vim.opt.swapfile = false -- Ask what state to recover when opening a file that was not saved.
vim.opt.showtabline = 1 -- If more than 1 show tabline
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.tabstop = 2 -- Insert 2 spaces for a tab
vim.opt.shiftwidth = 2 -- Number of space inserted for indentation.
vim.opt.autoindent = true -- Copy indent from current line
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time good for whichkey
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!
vim.opt.whichwrap = '<,>,[,],l,h' -- Which characters can go through wrap on a line

vim.opt.colorcolumn = '80' -- PEP8 like character limit vertical bar.
-- vim.opt.mousescroll = 'ver:2,hor:5' -- Disables hozirontal scroll in neovim.
-- vim.opt.guicursor = 'n:blinkon200,i-ci-ve:ver25' -- Enable cursor blink.
vim.opt.guicursor = {
  'n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
  'i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100',
  'r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100',
}
vim.opt.autochdir = true -- Use current file dir as working dir (See project.nvim).
vim.opt.scrolloff = 10 -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cursor centered.
vim.opt.sidescrolloff = 10 -- Same but for side scrolling.
vim.opt.selection = 'old' -- Don't select the newline symbol when using <End> on visual mode.

-- vim: ts=2 sts=2 sw=2 et
