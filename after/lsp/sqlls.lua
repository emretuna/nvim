local util = require 'lspconfig.util'
return {
  cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
  -- filetypes = { 'sql', 'mysql' },
  root_markers = { '.sqllsrc.json' },
  root_dir = util.root_pattern '.sqllsrc.json',
  settings = {},
}
