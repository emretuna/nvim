local add = MiniDeps.add

add {
  source = 'NickvanDyke/opencode.nvim',
  depends = {
    'folke/snacks.nvim',
  },
}

vim.g.opencode_opts = {
  terminal = {
    enter = true,
  },
}

-- Listen for opencode events
vim.api.nvim_create_autocmd('User', {
  pattern = 'OpencodeEvent',
  callback = function(args)
    -- See the available event types and their properties
    vim.notify(vim.inspect(args.data), vim.log.levels.DEBUG)
    -- Do something interesting, like show a notification when opencode finishes responding
    if args.data.type == 'session.idle' then
      vim.notify('Opencode finished the taks.', vim.log.levels.INFO)
    end
  end,
})
vim.keymap.set('n', '<leader>ao', function()
  require('opencode').toggle()
end, { desc = 'Toggle opencode' })
vim.keymap.set('n', '<leader>aa', function()
  require('opencode').ask()
end, { desc = 'Ask opencode' })
vim.keymap.set('n', '<leader>ac', function()
  require('opencode').ask '@cursor: '
end, { desc = 'Ask opencode about cursor' })
vim.keymap.set('v', '<leader>as', function()
  require('opencode').ask '@selection: '
end, { desc = 'Ask opencode about selection' })
vim.keymap.set('n', '<leader>an', function()
  require('opencode').command 'session_new'
end, { desc = 'New opencode session' })
vim.keymap.set('n', '<leader>ay', function()
  require('opencode').command 'messages_copy'
end, { desc = 'Copy last opencode response' })
vim.keymap.set('n', '<S-C-u>', function()
  require('opencode').command 'messages_half_page_up'
end, { desc = 'Messages half page up' })
vim.keymap.set('n', '<S-C-d>', function()
  require('opencode').command 'messages_half_page_down'
end, { desc = 'Messages half page down' })
vim.keymap.set({ 'n', 'v' }, '<leader>a.', function()
  require('opencode').select()
end, { desc = 'Select opencode prompt' })
