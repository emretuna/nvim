-- [[ Setting options ]]
-- See `:help vim.o`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.cmdheight = 0 -- Hide command line spacing

-- vim.o.autoread = true -- Set to auto read when a file is changed from the outside
vim.o.jumpoptions = ''
-- Netrw settings
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 25
vim.g.netrw_altv = 1

-- Fold settings
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = 'expr'
-- vim.o.foldtext = ''
vim.o.foldcolumn = '0'
-- vim.o.fillchars:append { fold = ' ' }

-- Default to treesitter folding
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- settings for vim-startuptime
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

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true
vim.o.spell = false
vim.o.spelllang = 'en_us'

-- AI assistant configuration
vim.g.ai_assistant = 'codeium' -- or supermaven

-- vim.o.list = true
-- vim.o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.shada = "!,'1000,<50,s10,h" -- Remember the last 1000 opened files
vim.o.undodir = vim.fn.stdpath 'data' .. '/undodir' -- Chooses where to store the undodir.
vim.o.history = 1000 -- Number of commands to remember in a history table (per buffer).
vim.o.swapfile = false -- Ask what state to recover when opening a file that was not saved.
vim.o.showtabline = 2 -- Always show tabs
vim.o.clipboard = 'unnamedplus' -- Use system clipboard
vim.o.tabstop = 2 -- Insert 2 spaces for a tab
vim.o.shiftwidth = 2 -- Number of space inserted for indentation.
vim.o.autoindent = true -- Copy indent from current line
vim.o.updatetime = 250 -- Decrease update time
vim.o.inccommand = 'split' -- Preview substitutions live, as you type!
vim.o.whichwrap = '<,>,[,],l,h' -- Which characters can go through wrap on a line
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal'
vim.o.colorcolumn = '80' -- PEP8 like character limit vertical bar.
-- vim.o.mousescroll = 'ver:2,hor:5' -- Disables hozirontal scroll in neovim.
vim.o.guicursor =
  'n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100,i-ci:ver25-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100,r:hor50-Cursor/lCursor-blinkwait100-blinkon100-blinkoff100'

vim.o.scrolloff = 10 -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cursor centered.
vim.o.sidescrolloff = 10 -- Same but for side scrolling.
vim.o.selection = 'old' -- Don't select the newline symbol when using <End> on visual mode.

local disabled_plugins = {
  '2html_plugin',
  'bugreport',
  'ftplugin',
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'matchit',
  'matchparen',
  -- 'netrw',
  -- 'netrwFileHandlers',
  -- 'netrwPlugin',
  -- 'netrwSettings',
  'optwin',
  'osc52',
  'rplugin',
  'rrhelper',
  'synmenu',
  'syntax',
  'tar',
  'tarPlugin',
  'tohtml',
  'tutor',
  'zip',
  'zipPlugin',
}
for i = 1, #disabled_plugins do
  vim.g['loaded_' .. disabled_plugins[i]] = 1
end

-- vim: ts=2 sts=2 sw=2 et
