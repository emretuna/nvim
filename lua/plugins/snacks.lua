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
  image = {
    enabled = true,
    doc = {
      inline = false,
      float = false,
      max_width = 30,
      max_height = 20,
    },
  },
}

local Snacks = require 'snacks'

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesActionRename, MiniFilesActionMove',
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})
vim.api.nvim_create_user_command('LazyGit', function()
  Snacks.lazygit { win = { border = vim.g.border_style, backdrop = false } }
end, { desc = 'Open LazyGit' })

vim.keymap.set('n', '<leader>g.', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })

vim.keymap.set('n', '<F7>', function()
  Snacks.terminal.open(nil, { win = { relative = 'editor', position = 'bottom', height = 20 } })
end, { desc = 'Toggle Terminal' })

vim.keymap.set('n', '<C-\\>', function()
  Snacks.terminal(nil, { win = { border = vim.g.border_style, position = 'float', backdrop = false } })
end, { desc = 'Terminal' })

vim.keymap.set('n', '<leader>mc', function()
  Snacks.terminal(
    { 'bunx', 'ccusage', 'blocks', '--live', '--timezone Europe/Istanbul' },
    { win = { border = vim.g.border_style, position = 'float', height = 20, backdrop = false, title = 'Claude Monitor' }, interactive = false }
  )
end, { desc = 'Claude Usage' })

vim.keymap.set('n', '<leader>mt', function()
  Snacks.terminal.open(
    { 'tokei' },
    { win = { style = 'minimal', relative = 'editor', position = 'bottom', title = 'Tokei', height = 20 }, interactive = false }
  )
end, { desc = 'Tokei' })

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

vim.keymap.set('n', '<leader>mi', function()
  Snacks.image.hover()
end, { desc = 'Image Hover' })
