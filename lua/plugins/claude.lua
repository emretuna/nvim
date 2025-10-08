local add = MiniDeps.add

add {
  source = 'coder/claudecode.nvim',
}

require('claudecode').setup {
  focus_after_send = true,
  terminal = {
    provider = 'snacks',
    snacks_win_opts = {
      border = vim.g.border_style,
      width = 64,
    },
  },
  diff_opts = {
    keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens
  },
}

vim.keymap.set('n', '<leader>cc', '<cmd>ClaudeCode<cr>', { desc = 'Toggle Claude' })
vim.keymap.set('n', '<leader>cf', '<cmd>ClaudeCodeFocus<cr>', { desc = 'Focus Claude' })
vim.keymap.set('n', '<leader>cr', '<cmd>ClaudeCode --resume<cr>', { desc = 'Resume Claude' })
vim.keymap.set('n', '<leader>cC', '<cmd>ClaudeCode --continue<cr>', { desc = 'Continue Claude' })
vim.keymap.set('n', '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', { desc = 'Add current buffer' })
vim.keymap.set('v', '<leader>cs', '<cmd>ClaudeCodeSend<cr>', { desc = 'Send to Claude' })
vim.keymap.set('n', '<leader>ct', '<cmd>ClaudeCodeTreeAdd<cr>', { desc = 'Add Tree' })
vim.keymap.set('n', '<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', { desc = 'Accept diff' })
vim.keymap.set('n', '<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>', { desc = 'Deny diff' })
