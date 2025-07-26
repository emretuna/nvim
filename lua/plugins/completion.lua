local add = MiniDeps.add

add {
  source = 'Saghen/blink.cmp',
  depends = {
    'mikavilpas/blink-ripgrep.nvim',
    'rafamadriz/friendly-snippets',
    'Kaiser-Yang/blink-cmp-avante',
  },
  checkout = 'v1.5.1',
}

require('blink.cmp').setup {
  fuzzy = {
    prebuilt_binaries = { download = true, force_version = 'v1.5.1' },
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
    accept = {
      auto_brackets = { enabled = false },
      dot_repeat = false,
    },
    menu = {
      min_width = 40,
      max_height = 20,
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
      menu = {
        auto_show = function(ctx)
          return ctx.mode ~= 'default'
        end,
      },
      list = { selection = { preselect = false, auto_insert = false } },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'markdown', 'avante' },
    min_keyword_length = 0,
    per_filetype = { sql = { 'dadbod', 'lsp' } },
    providers = {
      avante = {
        module = 'blink-cmp-avante',
        name = 'Avante',
        opts = {
          -- options for blink-cmp-avante
          avante = {
            command = {
              get_kind_name = function(_)
                return 'AvanteCmd'
              end,
            },
            mention = {
              get_kind_name = function(_)
                return 'AvanteMention'
              end,
            },
          },
        },
      },
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
