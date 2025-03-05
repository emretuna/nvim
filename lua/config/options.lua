-- [[ Setting options ]]
-- See `:help vim.opt`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.cmdheight = 0 -- Hide command line spacing

-- Netrw settings
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_winsize = 25
vim.g.netrw_altv = 1

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

-- Enable lsp rounded borders
vim.g.lsp_round_borders_enabled = true
-- Enable cmp rounded borders
vim.g.completion_round_borders_enabled = true

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true
vim.o.spell = false
vim.o.spelllang = 'en_us'

-- AI assistant configuration
vim.g.ai_assistant = 'codeium' -- or supermaven

-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

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
vim.opt.scrolloff = 10 -- Number of lines to leave before/after the cursor when scrolling. Setting a high value keep the cursor centered.
vim.opt.sidescrolloff = 10 -- Same but for side scrolling.
vim.opt.selection = 'old' -- Don't select the newline symbol when using <End> on visual mode.

local disabled_plugins = {
  'gzip',
  'matchit',
  'matchparen',
  'netrwPlugin',
  'rplugin',
  'tarPlugin',
  'tutor',
  'zipPlugin',
  '2html_plugin',
  'osc52',
  'tohtml',
  'getscript',
  'getscriptPlugin',
  'logipat',
  'netrw',
  'netrwSettings',
  'netrwFileHandlers',
  'tar',
  'rrhelper',
  'zip',
  'syntax',
  'synmenu',
  'optwin',
  'bugreport',
  'ftplugin',
}
for i = 1, #disabled_plugins do
  vim.g['loaded_' .. disabled_plugins[i]] = 1
end

-- vim: ts=2 sts=2 sw=2 et
