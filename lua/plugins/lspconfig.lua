local add = MiniDeps.add
add {
  source = 'neovim/nvim-lspconfig',
  -- Supply dependencies near target plugin
  depends = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'b0o/schemastore.nvim',
    'folke/lazydev.nvim',
    'saghen/blink.cmp',
  },
}

vim.cmd 'LspStart'

require('lspconfig.ui.windows').default_options.border = vim.g.border_style
local home = os.getenv 'HOME'
-- LSP provides Neovim with features like:
--  - Go to definition
--  - Find references
--  - Autocompletion
--  - Symbol Search
--  - and more!
--
-- Thus, Language Servers are external tools that must be installed separately from
-- Neovim. This is where `mason` and related plugins come into play.
--
-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- and elegantly composed help section, `:help lsp-vs-treesitter`

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer

---@diagnostic disable-next-line: missing-fields
require('lazydev').setup {
  library = {
    -- Load luvit types when the `vim.uv` word is found
    { path = 'luvit-meta/library', words = { 'vim%.uv' } },
  },
}
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    --  replaced with stacks.nvim
    map('<F2>', vim.lsp.buf.rename, 'LSP: Rename')
    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('ga', vim.lsp.buf.code_action, 'LSP: Code Action')
    -- Restart LSP server
    map('grR', '<cmd>:LspRestart<cr>', 'LSP Restart')

    map('gd', function()
      require('mini.extra').pickers.lsp { scope = 'definition' }
    end, 'Goto Ddefinition')

    map('gr', function()
      require('mini.extra').pickers.lsp { scope = 'references' }
    end, 'Goto References')

    map('gI', function()
      require('mini.extra').pickers.lsp { scope = 'implementation' }
    end, 'Goto Implementation')

    map('gD', function()
      require('mini.extra').pickers.lsp { scope = 'declaration' }
    end, 'Goto Declaration')

    map('gt', function()
      require('mini.extra').pickers.lsp { scope = 'type_definition' }
    end, 'Type [D]definition')

    -- map("<leader>ds", function()
    --   require('mini.extra').pickers.lsp({ scope = "document_symbol" })
    -- end, "[D]ocument [S]symbols")
    --
    -- map("<leader>ws", function()
    --   require('mini.extra').pickers.lsp({ scope = "workspace_symbol" })
    -- end, "[W]orkspace [S]symbols")
    -- Opens a popup that displays documentation about the word under your cursor
    --  See `:help K` for why this keymap.
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('gK', vim.lsp.buf.signature_help, 'LSP: Signature Help')
    vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'LSP: Signature Help' })
    -- Diagnostic keymaps
    -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'LSP: Previous Diagnostic Message' })
    -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'LSP: Next Diagnostic Message' })

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
    end

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
      end,
    })

    vim.diagnostic.config {
      signs = {
        active = true,
        values = {
          { name = 'DiagnosticSignError', text = '' },
          { name = 'DiagnosticSignWarn', text = '' },
          { name = 'DiagnosticSignHint', text = '󰌶' },
          { name = 'DiagnosticSignInfo', text = '' },
        },
      },
      virtual_text = true,
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      float = {
        focusable = true,
        style = 'minimal',
        border = vim.g.border_style,
        source = 'if_many',
        header = '',
        prefix = '',
      },
    }
  end,
})

local signs = { Error = ' ', Warn = ' ', Hint = '󰠠 ', Info = ' ' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities(capabilities))

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or vim.g.border_style
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

pcall(require, 'schemastore')

-- Set default diagnostics

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`tsserver`) will work just fine
  -- tsserver = {},
  --

  lua_ls = {
    -- cmd = {...},
    -- filetypes = { ...},
    -- capabilities = {},
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = {
          checkThirdParty = false,
        },
        completion = {
          callSnippet = 'Replace',
          displayContext = 10,
          keywordSnippet = 'Both',
        },
        diagnostics = {
          globals = { 'vim' },
          disable = { 'missing-fields', 'undefined-global' },
        },
        codeLens = {
          enable = true,
        },
        doc = {
          privateName = { '^_' },
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = 'Disable',
          semicolon = 'Disable',
          arrayIndex = 'Disable',
        },
      },
    },
  },
  html = {},
  cssls = {},
  graphql = {
    filetypes = { 'graphql', 'gql', 'svelte', 'typescriptreact', 'javascriptreact' },
  },
  intelephense = {
    completion = {
      enabled = true,
    },
    format = {
      enable = false, -- use boolean
    },
    settings = {
      intelephense = {
        telemetry = {
          enabled = false,
        },
        stubs = {
          'acf-pro',
          'bcmath',
          'bz2',
          'calendar',
          'Core',
          'curl',
          'date',
          'exif',
          'json',
          'genesis',
          'polylang',
          'Relection',
          'wordpress',
          'wordpress-globals',
          'woocommerce',
          'wp-cli',
          'zip',
          'zlib',
        },
        diagnostics = {
          enable = true,
        },
        environment = {
          includePaths = home .. '~/.composer/vendor/php-stubs/',
        },
        files = {
          maxSize = 5000000,
        },
      },
    },
  },
  jsonls = {
    schemas = require('schemastore').json.schemas(),
    validate = { enable = true },
  },
  yamlls = {
    schemaStore = {
      -- You must disable built-in schemaStore support if you want to use
      -- this plugin and its advanced options like `ignore`.
      enable = false,
      -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
      url = '',
    },
    schemas = require('schemastore').yaml.schemas(),
  },
}

-- Ensure the servers and tools above are installed
--  To check the current status of installed tools and/or manually install
--  other tools, you can run
--    :Mason
--
--  You can press `g?` for help in this menu.
require('mason').setup()

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'blade-formatter',
  'cssls',
  'css_variables',
  'dockerls',
  'docker_compose_language_service',
  'emmet-language-server',
  'eslint_d', -- js linter
  'gitui',
  'graphql',
  'html',
  'intelephense',
  'jq',
  'jsonls',
  -- 'kulala_ls',
  'lua_ls',
  'markdownlint',
  'php-cs-fixer',
  'phpstan',
  'phpcbf',
  'phpcs',
  'pint',
  'prettier', -- prettier formatter
  'prettierd', -- prettier daemon
  'prismals',
  'stylua', -- Used to format Lua code
  'tailwindcss',
  'typos',
  'yamlls',
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

--@diagnostic disable-next-line: missing-fields
require('mason-lspconfig').setup {
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      -- This handles overriding only values explicitly passed
      -- by the server configuration above. Useful when disabling
      -- certain features of an LSP (for example, turning off formatting for tsserver)
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      require('lspconfig')[server_name].setup(server)
    end,
  },
}
