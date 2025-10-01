local add = MiniDeps.add

add {
  source = 'folke/sidekick.nvim',
}

require('sidekick').setup {
  cli = {
    mux = 'tmux',
    enabled = true,
  },
}

vim.keymap.set('n', '<leader>as', function()
  require('sidekick.cli').toggle { name = 'opencode', focus = true }
end, { desc = 'Sidekick' })
