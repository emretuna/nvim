local add = MiniDeps.add

add {
  source = 'sphamba/smear-cursor.nvim',
}

require('smear_cursor').setup {
  stiffness = 0.5,
  trailing_stiffness = 0.5,
  matrix_pixel_threshold = 0.5,
}

vim.keymap.set('n', [[\S]], '<cmd>SmearCursorToggle<cr>', { desc = 'Toggle smear cursor' })
