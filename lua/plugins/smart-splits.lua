return {
  'mrjones2014/smart-splits.nvim',
  event = 'VeryLazy',
  config = function()
    require('smart-splits').setup()
    -- recommended mappings
    -- resizing splits
    -- these keymaps will also accept a range,
    -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
    vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
    vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
    vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
    vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
    -- moving between splits
    vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
    vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
    vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
    vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
    vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
    -- swapping buffers between windows
    vim.keymap.set('n', 'wh', require('smart-splits').swap_buf_left, { desc = 'Swap Buffer Left' })
    vim.keymap.set('n', 'wj', require('smart-splits').swap_buf_down, { desc = 'Swap Buffer Down' })
    vim.keymap.set('n', 'wk', require('smart-splits').swap_buf_up, { desc = 'Swap Buffer Up' })
    vim.keymap.set('n', 'wl', require('smart-splits').swap_buf_right, { desc = 'Swap Buffer Right' })
  end,
}
