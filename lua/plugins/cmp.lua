return {
  { -- Autocompletion
    -- 'hrsh7th/nvim-cmp',
    'iguanacucumber/magazine.nvim',
    version = '*',
    name = 'nvim-cmp', -- Otherwise highlighting gets messed up
    event = 'InsertEnter',
    -- enabled = false,
    dependencies = {
      'monkoose/neocodeium',
      'onsails/lspkind.nvim',
      'lukas-reineke/cmp-rg',
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      {
        'petertriho/cmp-git',
        opts = {},
        config = function()
          local cmp = require 'cmp'
          cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
              { name = 'git', priority = 50 },
              { name = 'path', priority = 40 },
            }, {
              { name = 'buffer', priority = 50 },
            }),
          })
        end,
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      { 'iguanacucumber/mag-nvim-lsp', name = 'cmp-nvim-lsp', opts = {} },
      { 'iguanacucumber/mag-nvim-lua', name = 'cmp-nvim-lua' },
      { 'iguanacucumber/mag-buffer', name = 'cmp-buffer' },
      { 'iguanacucumber/mag-cmdline', name = 'cmp-cmdline' },
      'https://codeberg.org/FelipeLema/cmp-async-path', -- not by me, but better than cmp-path
      'hrsh7th/cmp-emoji',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      -- Initialize AI assistant based on configuration
      local ai_module
      if vim.g.ai_assistant == 'codeium' then
        ai_module = {
          clear = function()
            require('neocodeium').clear()
          end,
          complete = function()
            require('neocodeium').cycle_or_complete()
          end,
        }
      elseif vim.g.ai_assistant == 'supermaven' then
        ai_module = {
          clear = function()
            require('supermaven-nvim.api').stop()
          end,
          complete = function()
            require('supermaven-nvim.api').start()
          end,
        }
      end
      cmp.event:on('menu_opened', function()
        ai_module.clear()
      end)
      cmp.event:on('menu_closed', function()
        ai_module.complete()
      end)
      -- border opts
      local border_opts = {
        border = vim.g.border_style,
        winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
      }
      local window_opts = {
        completion = cmp.config.window.bordered(border_opts),
        documentation = cmp.config.window.bordered(border_opts),
      }
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        window = vim.g.completion_round_borders_enabled and window_opts or {},
        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          -- Alternate mapping
          ['<Up>'] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
          },
          ['<Down>'] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
          },

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<Tab>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip', priority = 750 },
          { name = 'nvim_lua', priority = 750 },
          { name = 'lazydev', priority = 500 },
          { name = 'async_path', priority = 500 },
          {
            name = 'rg',
            -- Try it when you feel cmp performance is poor
            keyword_length = 3,
          },
          { name = 'emoji', priority = 50 },
        },
        formatting = {
          expandable_indicator = true,
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local icon, hl = require('mini.icons').get('lsp', vim_item.kind)
            vim_item.kind = icon .. ' ' .. vim_item.kind
            vim_item.kind_hl_group = hl
            local color = entry.completion_item.documentation
            if color and type(color) == 'string' and color:match '^#%x%x%x%x%x%x$' then
              local hl = 'hex-' .. color:sub(2)

              if #vim.api.nvim_get_hl(0, { name = hl }) == 0 then
                vim.api.nvim_set_hl(0, hl, { fg = color })
              end

              vim_item.menu = '█'
              -- vim_item.menu = ''
              vim_item.menu_hl_group = hl

              -- else
              -- add your lspkind icon here!
              -- vim_item.menu_hl_group = vim_item.kind_hl_group
            end
            return vim_item
          end,
        },
      }
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
        matching = { disallow_symbol_nonprefix_matching = false },
      })
    end,
  },
}
