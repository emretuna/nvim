local add = MiniDeps.add
add {
  source = 'brenoprata10/nvim-highlight-colors',
}
require('nvim-highlight-colors').setup {
  ---Render style
  ---@usage 'background'|'foreground'|'virtual'
  render = 'virtual',
  virtualtext = ' ',
  ---Set virtual symbol position()
  ---@usage 'inline'|'eol'|'eow'
  ---inline mimics VS Code style
  ---eol stands for `end of column` - Recommended to set `virtual_symbol_suffix = ''` when used.
  ---eow stands for `end of word` - Recommended to set `virtual_symbol_prefix = ' ' and
  virtual_symbol_position = 'eol',
  enable_tailwind = true,
  -- Exclude filetypes or buftypes from highlighting e.g. 'exclude_buftypes = {'text'}'
  exclude_filetypes = {},
  exclude_buftypes = {},
}
