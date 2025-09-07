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

vim.keymap.set('n', '<leader>ao', '<cmd>lua require("opencode").toggle()<cr>', { desc = 'Toggle embedded opencode' })
vim.keymap.set('n', '<leader>aa', '<cmd>lua require("opencode").ask()<cr>', { desc = 'Ask opencode' })
vim.keymap.set('n', '<leader>ap', '<cmd>lua require("opencode").select_prompt()<cr>', { desc = 'Select prompt' })
vim.keymap.set('n', '<leader>an', '<cmd>lua require("opencode").command("session_new")<cr>', { desc = 'New session' })
vim.keymap.set('n', '<leader>ay', '<cmd>lua require("opencode").command("messages_copy")<cr>', { desc = 'Copy last message' })
vim.keymap.set('n', '<S-C-u>', '<cmd>lua require("opencode").command("messages_half_page_up")<cr>', { desc = 'Scroll messages up' })
vim.keymap.set('n', '<S-C-d>', '<cmd>lua require("opencode").command("messages_half_page_down")<cr>', { desc = 'Scroll messages down' })
