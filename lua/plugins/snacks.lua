local add = MiniDeps.add

add {
  source = 'folke/snacks.nvim',
}

require('snacks').setup {
  input = {
    enabled = true,
    styles = {
      border = vim.g.border_style,
    },
  },
  bigfile = {
    enabled = true,
  },
  terminal = {
    enabled = true,
  },
  image = {
    enabled = true,
  },
}

local Snacks = require 'snacks'

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesActionRename, MiniFilesActionMove',
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})

vim.keymap.set('n', '<leader>g.', function()
  Snacks.lazygit { win = { border = vim.g.border_style, backdrop = false } }
end, { desc = 'LazyGit' })

vim.keymap.set('n', '<F7>', function()
  Snacks.terminal.open(nil, { win = { relative = 'editor', position = 'bottom', height = 20 } })
end, { desc = 'Toggle Terminal' })

vim.keymap.set('n', '<C-\\>', function()
  Snacks.terminal(nil, { win = { border = vim.g.border_style, position = 'float', backdrop = false } })
end, { desc = 'Terminal' })

vim.keymap.set('n', '<leader>mc', function()
  Snacks.terminal(
    { 'claude-monitor', '--plan', 'pro' },
    { win = { border = vim.g.border_style, position = 'float', backdrop = false, title = 'Claude Monitor' } }
  )
end, { desc = 'Claude Monitor' })

vim.keymap.set('n', '<leader>mR', function()
  Snacks.rename.rename_file()
end, { desc = 'Rename File' })

vim.keymap.set('n', '<leader>mb', function()
  Snacks.gitbrowse()
end, { desc = 'Git Browse' })

vim.keymap.set('n', '<leader>mz', function()
  Snacks.zen()
end, { desc = 'Zen Mode' })

vim.keymap.set('n', '<leader>mZ', function()
  Snacks.zen.zoom()
end, { desc = 'Zen Zoom' })
