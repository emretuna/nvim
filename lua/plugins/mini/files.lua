require('mini.files').setup {
  options = {
    permanent_delete = false,
  },
  mappings = {
    -- go_in = '<S-Enter>',
    -- go_in_plus = '<Enter>',
    go_in = 'L',
    go_in_plus = 'l',
    go_out = 'h',
    go_out_plus = 'H',
    synchronize = '<C-s>',
  },
  windows = {
    max_number = 3,
    preview = true,
    width_nofocus = math.floor((vim.o.columns - 5) * 0.25), -- 25% of screen minus border+padding
    width_focus = math.floor((vim.o.columns - 5) * 0.25), -- 25% of screen minus border+padding
    width_preview = math.floor((vim.o.columns - 3) * 0.5), -- 50% of screen minus border+padding,
  },
  border = vim.g.border_style,
}
vim.keymap.set('n', '_', '<CMD>lua MiniFiles.open()<CR>', { desc = 'Mini Files' })
vim.keymap.set('n', '-', '<CMD>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', { desc = 'Mini Files' })
vim.api.nvim_create_autocmd('User', {
  pattern = { 'MiniFilesWindowOpen', 'MiniFilesWindowUpdate' },
  callback = function(args)
    local win_id = args.data.win_id

    -- Customize window-local settings
    local config = vim.api.nvim_win_get_config(win_id)
    config.border = vim.g.border_style
    -- Make window full height to make it look TUI File manager
    -- config.height = vim.o.lines
    vim.api.nvim_win_set_config(win_id, config)
  end,
})
local map_split = function(buf_id, lhs, direction)
  local rhs = function()
    -- Make new window and set it as target
    local cur_target = MiniFiles.get_explorer_state().target_window
    local new_target = vim.api.nvim_win_call(cur_target, function()
      vim.cmd(direction .. ' split')
      return vim.api.nvim_get_current_win()
    end)

    MiniFiles.set_target_window(new_target)
    MiniFiles.go_in()
    -- This intentionally doesn't act on file under cursor in favor of
    -- explicit "go in" action (`l` / `L`). To immediately open file,
    -- add appropriate `MiniFiles.go_in()` call instead of this comment.
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = 'Split ' .. direction
  vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local buf_id = args.data.buf_id
    -- Tweak keys to your liking
    map_split(buf_id, '<C-h>', 'belowright horizontal')
    map_split(buf_id, '<C-v>', 'belowright vertical')
  end,
})
return {}
