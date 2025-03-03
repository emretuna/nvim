local add = MiniDeps.add
add {
  source = 'danymat/neogen',
}
require('neogen').setup {
  snippet_engine = 'luasnip',
}
