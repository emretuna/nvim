require('mini.tabline').setup {
  show_icons = true,
  format = function(buf_id, label)
    local suffix = vim.bo[buf_id].modified and ' ' or ''
    return MiniTabline.default_format(buf_id, label) .. suffix
  end,
}
