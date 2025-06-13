local utils = require 'config.utils'
local add = MiniDeps.add
add {
  source = 'neovim/nvim-lspconfig',
  -- Supply dependencies near target plugin
  depends = { -- Automatically install LSPs and related tools to stdpath for Neovim
    -- 'williamboman/mason-lspconfig.nvim',
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'b0o/schemastore.nvim',
    'folke/lazydev.nvim',
    'folke/neoconf.nvim',
  },
}

require('neoconf').setup()

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
    'mini.nvim',
    'MiniDeps', -- Load luvit types when the `vim.uv` word is found
    {
      path = 'luvit-meta/library',
      words = { 'vim%.uv' },
    },
  },
}
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', {
    clear = true,
  }),
  callback = function(event)
    -- NOTE: Remember that Lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, {
        buffer = event.buf,
        desc = 'LSP: ' .. desc,
      })
    end

    -- Rename the variable under your cursor.
    --  Most Language Servers support renaming across files, etc.
    --  replaced with stacks.nvim
    map('grn', vim.lsp.buf.rename, 'LSP: Rename')
    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map('gra', vim.lsp.buf.code_action, 'LSP: Code Action')

    -- Restart LSP server
    map('grR', '<cmd>:LspRestart<cr>', 'LSP: Restart')

    map('grd', function()
      require('mini.extra').pickers.lsp {
        scope = 'definition',
      }
    end, 'Goto Definition')

    map('grr', function()
      require('mini.extra').pickers.lsp {
        scope = 'references',
      }
    end, 'Goto References')

    map('gri', function()
      require('mini.extra').pickers.lsp {
        scope = 'implementation',
      }
    end, 'Goto Implementation')

    map('grD', function()
      require('mini.extra').pickers.lsp {
        scope = 'declaration',
      }
    end, 'Goto Declaration')

    map('grt', function()
      require('mini.extra').pickers.lsp {
        scope = 'type_definition',
      }
    end, 'Type Definition')

    -- map("g0", function()
    --   require('mini.extra').pickers.lsp({ scope = "document_symbol" })
    -- end, "Document Symbols")
    --
    -- map("gW", function()
    --   require('mini.extra').pickers.lsp({ scope = "workspace_symbol" })
    -- end, "Workspace Symbols")

    -- Opens a popup that displays documentation about the word under your cursor
    --  See `:help K` for why this keymap.
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('gK', vim.lsp.buf.signature_help, 'LSP: Signature Help')
    vim.keymap.set('i', '<c-k>', vim.lsp.buf.signature_help, {
      buffer = event.buf,
      desc = 'LSP: Signature Help',
    })
    -- Diagnostic keymaps
    -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'LSP: Previous Diagnostic Message' })
    -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'LSP: Next Diagnostic Message' })

    -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
    ---@param client vim.lsp.Client
    ---@param method vim.lsp.protocol.Method
    ---@param bufnr? integer some lsp support methods only in specific files
    ---@return boolean
    local function client_supports_method(client, method, bufnr)
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      else
        return client.supports_method(method, {
          bufnr = bufnr,
        })
      end
    end

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', {
        clear = false,
      })
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

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', {
          clear = true,
        }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds {
            group = 'kickstart-lsp-highlight',
            buffer = event2.buf,
          }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('[\\]h', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {
          bufnr = event.buf,
        })
      end, 'Toggle Inlay Hints')
    end
  end,
})
-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  severity_sort = true,
  update_in_insert = false,
  float = {
    focusable = true,
    style = 'minimal',
    border = vim.g.border_style,
    source = 'if_many',
    header = '',
    prefix = '',
  },
  underline = {
    severity = vim.diagnostic.severity.ERROR,
  },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    current_line = true,
    -- severity = { min = 'INFO', max = 'WARN' },
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
  -- virtual_lines = { current_line = true, severity = { min = 'ERROR' } },
}

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

-- Set floating window border style
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or vim.g.border_style
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
pcall(require, 'schemastore')

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
  mason = {
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
          runtime = {
            version = 'LuaJIT',
          },
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
    harper_ls = {
      enableSpellChecking = true,
      enableGrammarChecking = true,
      filetypes = { 'markdown', 'text', 'gitcommit', 'typescript', 'typescriptreact', 'sql' },
    },
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
      validate = {
        enable = true,
      },
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
    -- emmet_ls = {
    --   filetypes = {
    --     'astro',
    --     'css',
    --     'eruby',
    --     'html',
    --     'htmldjango',
    --     'javascriptreact',
    --     'less',
    --     'pug',
    --     'sass',
    --     'scss',
    --     'svelte',
    --     'typescriptreact',
    --     'vue',
    --     'htmlangular',
    --   },
    -- },
    sqlls = {
      cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
      filetypes = { 'sql', 'mysql' },
      root_dir = require('lspconfig').util.root_pattern { '.sqllsrc.json' },
    },
    postgres_lsp = {
      cmd = { 'postgrestools', 'lsp-proxy' },
      filetypes = { 'sql', 'psql' },
      root_dir = require('lspconfig').util.root_pattern { 'postgrestools.jsonc' },
    },
  },
  others = {
    -- dartls = {},
  },
}

-- Ensure the servers and tools above are installed
--  To check the current status of installed tools and/or manually install
--  other tools, you can run
--    :Mason
--
--  You can press `g?` for help in this menu.
require('mason').setup {
  ui = {
    border = vim.g.border_style,
  },
}

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
local ensure_installed = vim.tbl_keys(servers.mason or {})
vim.list_extend(ensure_installed, {
  'blade-formatter',
  'cssls',
  'css_variables', --  'deno',
  'dockerls',
  'docker_compose_language_service', -- 'emmet-ls',
  'eslint_d', -- js linter
  'graphql',
  'html',
  'harper-ls',
  'intelephense',
  'jq',
  'jsonls', -- 'kulala_ls',
  'lua_ls',
  'markdownlint',
  'php-cs-fixer',
  'phpstan',
  'phpcbf',
  'phpcs',
  'postgrestools',
  'pint',
  'prettier', -- prettier formatter
  'prettierd', -- prettier daemon
  'prismals',
  'stylua', -- Used to format Lua code
  'sqlls',
  'tailwindcss',
  'typos',
  'yamlls',
})

require('mason-tool-installer').setup {
  ensure_installed = ensure_installed,
}
-- Either merge all additional server configs from the `servers.mason` and `servers.others` tables
-- to the default language server configs as provided by nvim-lspconfig or
-- define a custom server config that's unavailable on nvim-lspconfig.
for server, config in pairs(vim.tbl_extend('keep', servers.mason, servers.others)) do
  if not vim.tbl_isempty(config) then
    vim.lsp.config(server, config)
  end
end

-- After configuring our language servers, we now enable them
require('mason-lspconfig').setup {
  ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
  automatic_enable = true, -- automatically run vim.lsp.enable() for all servers that are installed via Mason
}

-- Manually run vim.lsp.enable for all language servers that are *not* installed via Mason
if not vim.tbl_isempty(servers.others) then
  vim.lsp.enable(vim.tbl_keys(servers.others))
end
