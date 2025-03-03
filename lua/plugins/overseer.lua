local add = MiniDeps.add
add {
  source = 'stevearc/overseer.nvim',
}

require('overseer').setup()

-- Create custom command for restarting last task
vim.api.nvim_create_user_command('OverseerRestartLast', function()
  local overseer = require 'overseer'
  local tasks = overseer.list_tasks { recent_first = true }
  if vim.tbl_isempty(tasks) then
    vim.notify('No tasks found', vim.log.levels.WARN)
  else
    overseer.run_action(tasks[1], 'restart')
  end
end, {})

-- Overseer keymaps
vim.keymap.set('n', '<leader>ob', '<cmd>OverseerBuild<cr>', { desc = 'Task builder' })
vim.keymap.set('n', '<leader>oc', '<cmd>OverseerClearCache<cr>', { desc = 'Clear cache' })
vim.keymap.set('n', '<leader>oi', '<cmd>OverseerInfo<cr>', { desc = 'Overseer Info' })
vim.keymap.set('n', '<leader>ol', '<cmd>OverseerRestartLast<cr>', { desc = 'Run last task' })
vim.keymap.set('n', '<leader>oq', '<cmd>OverseerQuickAction<cr>', { desc = 'Action recent task' })
vim.keymap.set('n', '<leader>or', '<cmd>OverseerRun<cr>', { desc = 'Run task' })
vim.keymap.set('n', '<leader>ot', '<cmd>OverseerTaskAction<cr>', { desc = 'Task action' })
vim.keymap.set('n', '<leader>oT', '<cmd>OverseerToggle<cr>', { desc = 'Task list' })
