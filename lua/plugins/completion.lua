local add = MiniDeps.add

add {
  source = 'Saghen/blink.cmp',
  checkout = 'v1.0.0',
  depends = {
    'mikavilpas/blink-ripgrep.nvim',
    'saghen/blink.compat',
    'rafamadriz/friendly-snippets',
  },
}

require('blink.cmp').setup {
  fuzzy = {
    prebuilt_binaries = {
      download = true,
      force_version = 'v1.0.0',
    },
  },

  keymap = {
    preset = 'default',
    ['<C-e>'] = { 'hide', 'fallback' },
    ['<C-y>'] = { 'select_and_accept', 'fallback' },
  },

  appearance = {
    highlight_ns = vim.api.nvim_create_namespace 'blink_cmp',
    use_nvim_cmp_as_default = false,
  },

  completion = {
    list = {
      selection = { preselect = false, auto_insert = false },
    },
    accept = { auto_brackets = { enabled = false } },
    menu = {
      min_width = 35,
      border = vim.g.border_style,
      scrolloff = 2,
      scrollbar = false,
      draw = {
        columns = { { 'kind_icon' }, { 'label', 'kind', 'source_name', gap = 4 } },
        align_to = 'none',
        components = {
          label = { width = { min = 20, fill = true } }, -- default is true
          label_description = { width = { fill = true } },
          kind_icon = {
            text = function(ctx)
              local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
              return kind_icon
            end,
          },
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

  signature = {
    enabled = true,
    window = {
      direction_priority = { 'n', 's' },
      border = vim.g.border_style,
    },
  },
  cmdline = {
    enabled = true,

    keymap = { preset = 'cmdline' },
    completion = {
      menu = { auto_show = true },
      list = { selection = { preselect = false, auto_insert = false } },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'markdown', 'avante_commands', 'avante_mentions', 'avante_files' },
    min_keyword_length = 0,
    per_filetype = { sql = { 'dadbod' } },
    providers = {
      ripgrep = {
        module = 'blink-ripgrep',
        name = 'Ripgrep',
        ---@module "blink-ripgrep"
        ---@type blink-ripgrep.Options
        opts = {
          prefix_min_len = 4,
          score_offset = 10, -- should be lower priority
          max_filesize = '300K',
          search_casing = '--smart-case',
        },
      },
      lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100, fallbacks = { 'lsp' } },
      markdown = { name = 'RenderMarkdown', module = 'render-markdown.integ.blink', fallbacks = { 'lsp' } },
      avante_commands = {
        name = 'avante_commands',
        module = 'blink.compat.source',
        score_offset = 90, -- show at a higher priority than lsp
        opts = {},
      },
      avante_files = {
        name = 'avante_files',
        module = 'blink.compat.source',
        score_offset = 100, -- show at a higher priority than lsp
        opts = {},
      },
      avante_mentions = {
        name = 'avante_mentions',
        module = 'blink.compat.source',
        score_offset = 1000, -- show at a higher priority than lsp
        opts = {},
      },
      dadbod = {
        name = 'Dadbod',
        module = 'vim_dadbod_completion.blink',
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
  -- opts_extend = { 'sources.default' },
}
