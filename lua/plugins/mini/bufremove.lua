require('mini.bufremove').setup {
  set_vim_settings = false,
}
-- Function to remove all buffers except the current one
local function remove_all_but_current()
  local current_buf = vim.api.nvim_get_current_buf() -- Get the current buffer ID
  local buffers = vim.api.nvim_list_bufs() -- Get a list of all buffer IDs
  for _, buf_id in ipairs(buffers) do
    -- Only delete the buffer if it's not the current one
    if buf_id ~= current_buf then
      -- Use MiniBufremove.delete to delete the buffer
      local success = require('mini.bufremove').delete(buf_id, false) -- true = force delete
      if not success then
        print('Failed to delete buffer:', buf_id)
      end
    end
  end
end
vim.keymap.set('n', '<leader>bx', '<cmd>lua MiniBufremove.delete()<CR>', { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>bw', '<cmd>lua MiniBufremove.wipeout()<CR>', { desc = 'Wipeout Buffer' })
vim.keymap.set('n', '<leader>bc', function()
  remove_all_but_current()
end, { desc = 'Delete All Buffers' })

return {}
