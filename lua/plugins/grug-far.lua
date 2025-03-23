local add = MiniDeps.add
add {
  source = 'MagicDuck/grug-far.nvim',
}
require('grug-far').setup()
vim.keymap.set('n', '<leader>mg', function()
  local grug = require 'grug-far'
  local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
  grug.open {
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  }
end, {
  desc = 'Grug Far',
})
