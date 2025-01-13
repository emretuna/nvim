return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  enabled = false,
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      dependencies = { 'rafamadriz/friendly-snippets' },
    },
    'moyiz/blink-emoji.nvim',
    'Kaiser-Yang/blink-cmp-dictionary',
  },
  -- use a release tag to download pre-built binaries
  version = '*',
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- On musl libc based systems you need to add this flag
  -- build = 'RUSTFLAGS="-C target-feature=-crt-static" cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',
  event = { 'InsertEnter *', 'CmdlineEnter *' },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    fuzzy = {
      prebuilt_binaries = {
        download = true,
      },
    },
    appearance = {
      highlight_ns = vim.api.nvim_create_namespace 'blink_cmp',
      use_nvim_cmp_as_default = false,
      nerd_font_variant = 'mono',
    },
    -- experimental auto-brackets support
    -- accept = { auto_brackets = { enabled = true } }
    completion = {
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      keyword = { range = 'full' },
      accept = { auto_brackets = { enabled = true } },
      menu = {
        min_width = 35,
        border = vim.g.border_style,
        scrolloff = 2,
        scrollbar = false,
        draw = {
          columns = { { 'kind_icon' }, { 'label', 'kind', 'source_name', gap = 1 } },
          components = {
            label = { width = { min = 20, fill = true } }, -- default is true
            label_description = { width = { fill = true } },
            kind = {
              width = { fill = true },
              text = function(ctx)
                return '' .. ctx.kind .. ''
              end,
            },
            source_name = {
              width = { fill = true },
              text = function(ctx)
                return '[' .. ctx.source_name .. ']'
              end,
            },
          },
        },
      },
      documentation = {
        auto_show = true,
        window = {
          border = vim.g.border_style,
          min_width = 35,
          direction_priority = {
            menu_north = { 'e', 'w' },
            menu_south = { 'e', 'w' },
          },
        },
      },
      ghost_text = { enabled = false },
    },
  },
  signature = {
    enabled = true,
    window = {
      direction_priority = { 'n', 's' },
      border = vim.g.border_style,
    },
  },

  sources = {
    -- adding any nvim-cmp sources here will enable them
    -- with blink.compat
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'dadbod', 'emoji', 'dictionary' },
    cmdline = function()
      local type = vim.fn.getcmdtype()
      -- Search forward and backward
      if type == '/' or type == '?' then
        return { 'buffer' }
      end
      -- Commands
      if type == ':' then
        return { 'cmdline' }
      end
      return {}
    end,
    min_keyword_length = 0,
    providers = {
      path = {
        name = 'path',
        score_offset = 100,
      },
      lsp = {
        name = 'lsp',
        score_offset = 99,
      },
      lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100, fallbacks = { 'lsp' } },
      dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
      emoji = {
        name = 'Emoji',
        module = 'blink-emoji',
        score_offset = 15, -- the higher the number, the higher the priority
        opts = { insert = true }, -- Insert emoji (default) or complete its name
      },
      dictionary = {
        module = 'blink-cmp-dictionary',
        name = 'Dict',
        score_offset = 20, -- the higher the number, the higher the priority
        -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
        enabled = true,
        max_items = 8,
        min_keyword_length = 3,
        opts = {
          -- -- The dictionary by default now uses fzf, make sure to have it
          -- -- installed
          -- -- https://github.com/Kaiser-Yang/blink-cmp-dictionary/issues/2
          --
          -- Do not specify a file, just the path, and in the path you need to
          -- have your .txt files
          -- dictionary_directories = { vim.fn.expand '~/.dotfiles/dictionaries' },
          -- --  NOTE: To disable the definitions uncomment this section below
          -- separate_output = function(output)
          --   local items = {}
          --   for line in output:gmatch("[^\r\n]+") do
          --     table.insert(items, {
          --       label = line,
          --       insert_text = line,
          --       documentation = nil,
          --     })
          --   end
          --   return items
          -- end,
        },
      },
    },
  },
  snippets = {
    -- Function to use when expanding LSP provided snippets
    expand = function(snippet)
      vim.snippet.expand(snippet)
    end,
    -- Function to use when checking if a snippet is active
    active = function(filter)
      return vim.snippet.active(filter)
    end,
    -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
    jump = function(direction)
      vim.snippet.jump(direction)
    end,
  },
  keymap = {
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'cancel', 'hide', 'completion_menu_close', 'fallback' },
    ['<C-y>'] = { 'accept', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },

    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

    ['<Tab>'] = { 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
  },
  config = function(_, opts)
    require('blink.cmp').setup(opts)
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

    -- Only set up autocmds if an AI assistant is configured
    if ai_module then
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          ai_module.clear()
        end,
      })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function()
          ai_module.complete()
        end,
      })
    end
  end,
}
