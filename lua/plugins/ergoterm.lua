local add = require('mini.deps').add
add {
  source = 'waiting-for-dev/ergoterm.nvim',
}

require('ergoterm').setup {
  terminal_defaults = {
    float_opts = {
      border = vim.g.border_style,
    },
    float_winblend = 0,
  },
}

local terms = require 'ergoterm.terminal'
local lazygit = terms.Terminal:new {
  name = 'lazygit_term',
  cmd = 'lazygit',
  layout = 'float',
  -- dir = 'git_dir',
  selectable = false,
}
local claude_monitor = terms.Terminal:new {
  name = 'claude_monitor_term',
  cmd = 'claude-monitor --plan pro',
  layout = 'float',
  -- dir = 'git_dir',
  selectable = false,
}
vim.api.nvim_create_user_command('LazyGit', function()
  lazygit:toggle()
end, { desc = 'Toggle Lazygit' })
vim.keymap.set('n', '<leader>g.', function()
  lazygit:toggle()
end, { desc = 'Open lazygit' })

vim.keymap.set('n', '<leader>am', function()
  claude_monitor:toggle()
end, { desc = 'Claude Monitor' })

-- Terminal creation with different layouts
vim.keymap.set('n', '<F7>', ':TermNew layout=below<CR>', { desc = 'Terminal below', noremap = true, silent = true }) -- Split below
vim.keymap.set('n', '<leader>cv', ':TermNew layout=right<CR>', { desc = 'Terminal right', noremap = true, silent = true }) -- Vertical split
vim.keymap.set('n', '<leader>cf', ':TermNew layout=float<CR>', { desc = 'Terminal float', noremap = true, silent = true }) -- Floating window
vim.keymap.set('n', '<leader>ct', ':TermNew layout=tab<CR>', { desc = 'Terminal tab', noremap = true, silent = true }) -- New tab

-- Open terminal picker
vim.keymap.set('n', '<leader>c.', ':TermSelect<CR>', { desc = 'Select terminal', noremap = true, silent = true }) -- List and select terminals

-- Send text to last focused terminal
vim.keymap.set('n', '<leader>cs', ':TermSend! new_line=false<CR>', { desc = 'Send line without newline', noremap = true, silent = true }) -- Send line without newline
vim.keymap.set('x', '<leader>cs', ':TermSend! new_line=false<CR>', { desc = 'Send selection without newline', noremap = true, silent = true }) -- Send selection without newline

-- Send and show output without focusing terminal
vim.keymap.set('n', '<leader>cx', ':TermSend! action=visible<CR>', { desc = 'Execute in terminal, keep focus', noremap = true, silent = true }) -- Execute in terminal, keep focus
vim.keymap.set('x', '<leader>cx', ':TermSend! action=visible<CR>', { desc = 'Execute selection in terminal, keep focus', noremap = true, silent = true }) -- Execute selection in terminal, keep focus

-- Send as markdown code block
vim.keymap.set(
  'n',
  '<leader>cS',
  ':TermSend! action=visible trim=false decorator=markdown_code<CR>',
  { desc = 'Send as markdown code block', noremap = true, silent = true }
)
vim.keymap.set(
  'x',
  '<leader>cS',
  ':TermSend! action=visible trim=false decorator=markdown_code<CR>',
  { desc = 'Send selection as markdown code block', noremap = true, silent = true }
)
