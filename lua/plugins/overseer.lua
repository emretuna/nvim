return {
  'stevearc/overseer.nvim',
  config = function()
    require('overseer').setup()

    vim.api.nvim_create_user_command('OverseerRestartLast', function()
      local overseer = require 'overseer'
      local tasks = overseer.list_tasks { recent_first = true }
      if vim.tbl_isempty(tasks) then
        vim.notify('No tasks found', vim.log.levels.WARN)
      else
        overseer.run_action(tasks[1], 'restart')
      end
    end, {})
  end,
  cmd = {
    'OverseerOpen',
    'OverseerClose',
    'OverseerToggle',
    'OverseerSaveBundle',
    'OverseerLoadBundle',
    'OverseerDeleteBundle',
    'OverseerRunCmd',
    'OverseerRun',
    'OverseerInfo',
    'OverseerBuild',
    'OverseerQuickAction',
    'OverseerTaskAction',
    'OverseerClearCache',
    'OverseerRestartLast',
  },
  keys = {
    { '<leader>ob', '<cmd>OverseerBuild<cr>', desc = 'Task builder' },
    { '<leader>oc', '<cmd>OverseerClearCache<cr>', desc = 'Clear cache' },
    { '<leader>oi', '<cmd>OverseerInfo<cr>', desc = 'Overseer Info' },
    { '<leader>ol', '<cmd>OverseerRestartLast<cr>', desc = 'Run last task' },
    { '<leader>oq', '<cmd>OverseerQuickAction<cr>', desc = 'Action recent task' },
    { '<leader>or', '<cmd>OverseerRun<cr>', desc = 'Run task' },
    { '<leader>ot', '<cmd>OverseerTaskAction<cr>', desc = 'Task action' },
    { '<leader>oT', '<cmd>OverseerToggle<cr>', desc = 'Task list' },
  },
}
