local add = MiniDeps.add
add {
  source = 'dmmulroy/tsc.nvim',
  depends = {
    'dmmulroy/ts-error-translator.nvim',
  },
}
require('ts-error-translator').setup {
  auto_override_publish_diagnostics = true,
}

require('tsc').setup {
  use_trouble_qflist = true,
}
