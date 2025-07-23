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

require('sonarqube').setup {
  rules = {
    enabled = true,

    -- Enforce readable line lengths (adjust to your preference)
    ['typescript:S103'] = { enabled = true, parameters = { maximumLineLength = 180 } },

    -- 🐛 Bug detection
    ['typescript:S1481'] = { enabled = true }, -- Unused local variables should be removed
    ['typescript:S1848'] = { enabled = true }, -- Use shorthand syntax `{foo}` instead of `{foo: foo}`
    ['typescript:S3330'] = { enabled = true }, -- Use strict equality `===` instead of `==`

    -- 🧼 Code Quality / Readability
    ['typescript:S1121'] = { enabled = true }, -- Assignments should not be made from within sub-expressions
    ['typescript:S125'] = { enabled = true }, -- Commented-out code should be removed
    ['typescript:S110'] = { enabled = true }, -- Inheritance tree too deep (can be noisy in React, disable if needed)
    ['typescript:S1450'] = { enabled = true }, -- Private fields only used in one method should be local variables
    ['typescript:S1448'] = { enabled = true }, -- Avoid function declarations inside loops

    -- ✅ Maintainability
    ['typescript:S3776'] = { enabled = true, parameters = { maxCognitiveComplexity = 15 } }, -- Reduce method complexity
    ['typescript:S125'] = { enabled = true }, -- Remove commented-out code
    ['typescript:S2583'] = { enabled = true }, -- Conditions should not unconditionally evaluate to "true" or "false"

    -- 🛡️ Security
    ['typescript:S2076'] = { enabled = true }, -- OS command injection vulnerabilities
    ['typescript:S2092'] = { enabled = true }, -- Disabling HTML escaping can expose XSS
    ['typescript:S5332'] = { enabled = true }, -- Avoid using `eval()`

    -- ✨ Optional, but helpful in large teams:
    ['typescript:S4325'] = { enabled = true }, -- Classes should be named with PascalCase
    ['typescript:S4326'] = { enabled = true }, -- Interfaces should start with `I` (e.g., `IUser`) — personal/team preference

    -- 💡 For frontend specifically
    ['typescript:S3655'] = { enabled = true }, -- Proper use of optional chaining
    ['typescript:S3616'] = { enabled = true }, -- Avoid confusing non-null assertions (e.g., `foo!.bar`)
  },
}
