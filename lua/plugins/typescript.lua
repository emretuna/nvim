local add = MiniDeps.add

add {
  source = 'pmizio/typescript-tools.nvim',
  depends = {
    'nvim-lua/plenary.nvim',
    'neovim/nvim-lspconfig',
  },
}

require('typescript-tools').setup {
  settings = {
    -- tsserver_max_memory = 8192,
    code_lens_mode = 'all',
    expose_as_code_action = 'all',
    tsserver_file_preferences = {
      -- Enhanced completions
      includeCompletionsForModuleExports = true,
      includeCompletionsWithInsertText = true,
      includeCompletionsWithSnippetText = true,
      includeAutomaticOptionalChainCompletions = true,
      allowIncompleteCompletions = true,

      -- Inlay hints for better code readability
      includeInlayParameterNameHints = 'all',
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,

      -- Import organization
      importModuleSpecifierPreference = 'non-relative',
      importModuleSpecifierEnding = 'auto',
      allowTextChangesInNewFiles = true,
      providePrefixAndSuffixTextForRename = true,

      -- Code style
      quotePreference = 'single',
      preferTypeOnlyAutoImports = true,
    },
    tsserver_format_options = {
      -- Indentation
      convertTabsToSpaces = true,
      tabSize = 2,
      indentSize = 2,

      -- Spacing
      insertSpaceAfterCommaDelimiter = true,
      insertSpaceAfterSemicolonInForStatements = true,
      insertSpaceBeforeAndAfterBinaryOperators = true,
      insertSpaceAfterKeywordsInControlFlowStatements = true,
      insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
      insertSpaceBeforeFunctionParenthesis = false,
      insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
      insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
      insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,

      -- New lines
      placeOpenBraceOnNewLineForFunctions = false,
      placeOpenBraceOnNewLineForControlBlocks = false,

      -- Organization
      semicolons = 'insert',
      newLineCharacter = '\n',
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

add {
  source = 'dmmulroy/tsc.nvim',
}

require('tsc').setup {
  use_trouble_qflist = true,
}

add {
  source = 'dmmulroy/ts-error-translator.nvim',
}

require('ts-error-translator').setup {
  auto_override_publish_diagnostics = true,
}

add {
  source = 'iamkarasik/sonarqube.nvim',
  hooks = {
    post_checkout = function()
      vim.cmd 'SonarQubeInstallLsp'
    end,
  },
}

require('sonarqube').setup {}
