local add = MiniDeps.add
add {
  source = 'neovim/nvim-lspconfig',
  -- Supply dependencies near target plugin
  depends = { -- Automatically install LSPs and related tools to stdpath for Neovim
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'b0o/schemastore.nvim',
    'folke/lazydev.nvim',
    'artemave/workspace-diagnostics.nvim',
  },
}

local servers = {
  'cssls',
  'css_variables',
  'copilot',
  'denols',
  'dockerls',
  'docker_compose_language_service',
  'emmet_ls',
  'graphql',
  'html',
  'harper_ls',
  'intelephense',
  'jsonls',
  'kulala_ls',
  'lua_ls',
  'postgres_lsp',
  'prismals',
  'sqlls',
  'tailwindcss',
  'yamlls',
}
vim.lsp.enable(servers)
vim.lsp.inline_completion.enable()
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(nil, true),
  root_markers = { '.git' },
})

require('mason').setup {
  ui = {
    border = vim.g.border_style,
  },
}

require('mason-lspconfig').setup {
  ensure_installed = {},
  automatic_enable = false,
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'blade-formatter',
  'eslint_d', -- js linter
  'jq',
  'kulala-fmt',
  'markdownlint',
  'php-cs-fixer',
  'phpstan',
  'phpcbf',
  'phpcs',
  'pint',
  'prettier', -- prettier formatter
  'prettierd', -- prettier daemon
  'stylua', -- Used to format Lua code
  'typos',
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

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

    -- map('<leader>e', vim.diagnostic.open_float, 'Open floating diagnostic message')
    -- map('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')

    -- Lesser used LSP functionality
    map('<leader>ma', vim.lsp.buf.add_workspace_folder, 'Workspace Add Folder')
    map('<leader>me', vim.lsp.buf.remove_workspace_folder, 'Workspace Exclude Folder')
    map('<leader>ml', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, 'Workspace List Folders')

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
-- Populate workspace diagnostics on LSP attach
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      require('workspace-diagnostics').populate_workspace_diagnostics(client, 0)
    end
  end,
})
-- Set floating window border style
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or vim.g.border_style
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
