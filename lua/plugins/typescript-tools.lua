local add = MiniDeps.add
add {
  source = 'pmizio/typescript-tools.nvim',
  depends = {
    'nvim-lua/plenary.nvim',
    'dmmulroy/ts-error-translator.nvim',
  },
}
require('ts-error-translator').setup {
  auto_override_publish_diagnostics = true,
}

require('typescript-tools').setup {
  single_file_support = false,
  root_dir = require('lspconfig').util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git'),
  settings = {
    code_lens_mode = 'all',
    expose_as_code_action = 'all',
    jsx_close_tag = {
      enable = true,
      filetypes = { 'javascriptreact', 'typescriptreact' },
    },
    separate_diagnostic_server = true,
    publish_diagnostic_on = 'insert_leave',
    tsserver_max_memory = 'auto',
    complete_function_calls = true,
    tsserver_file_preferences = {
      includeCompletionsForModuleExports = true,
      includeInlayParameterNameHints = 'all',
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
      importModuleSpecifierPreference = 'non-relative',
      quotePreference = 'auto',
    },
    tsserver_format_options = {
      allowIncompleteCompletions = false,
      allowRenameOfImportPath = false,
    },
    tsserver_plugins = {
      '@vue/typescript-plugin',
      -- for TypeScript v4.9+
      '@styled/typescript-styled-plugin',
      -- or for older TypeScript versions
      -- "typescript-styled-plugin",
    },
  },
}
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.ts*',
  command = ':TSToolsRemoveUnusedImports sync',
})
