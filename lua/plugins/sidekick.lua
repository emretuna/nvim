local add = MiniDeps.add

add {
  source = 'folke/sidekick.nvim',
}

require('sidekick').setup {
  cli = {
    mux = {
      backend = 'tmux',
      enabled = true,
    },
  },
}
-- Next Edit Suggestion
vim.keymap.set({ 'n', 'i' }, '<tab>', function()
  if not require('sidekick').nes_jump_or_apply() then
    return '<Tab>'
  end
end, { expr = true, desc = 'Goto/Apply Next Edit Suggestion' })
-- Toggle Sidekick CLI
vim.keymap.set({ 'n', 't', 'i', 'x' }, '<c-.>', function()
  require('sidekick.cli').toggle()
end, { desc = 'Sidekick Toggle' })

-- Toggle Sidekick CLI (Leader)
vim.keymap.set('n', '<leader>aa', function()
  require('sidekick.cli').toggle()
end, { desc = 'Sidekick Toggle CLI' })

-- Select CLI
vim.keymap.set('n', '<leader>a.', function()
  -- require('sidekick.cli').select()
  require('sidekick.cli').select { filter = { installed = true } }
end, { desc = 'Select CLI' })

-- Send This (normal/visual)
vim.keymap.set({ 'n', 'x' }, '<leader>at', function()
  require('sidekick.cli').send { msg = '{this}' }
end, { desc = 'Send This' })

-- Send File
vim.keymap.set('n', '<leader>af', function()
  require('sidekick.cli').send { msg = '{file}' }
end, { desc = 'Send File' })

-- Send Visual Selection
vim.keymap.set('x', '<leader>av', function()
  require('sidekick.cli').send { msg = '{selection}' }
end, { desc = 'Send Visual Selection' })

-- Sidekick Select Prompt
vim.keymap.set({ 'n', 'x' }, '<leader>ap', function()
  require('sidekick.cli').prompt()
end, { desc = 'Sidekick Select Prompt' })

-- Toggle Claude directly
vim.keymap.set('n', '<leader>ac', function()
  require('sidekick.cli').toggle { name = 'claude', focus = true }
end, { desc = 'Sidekick Toggle Claude' })
