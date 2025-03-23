local add = MiniDeps.add

add {
  source = 'L3MON4D3/LuaSnip',
  checkout = 'master',
  hooks = { 'make install_jsregexp' },
  depends = { 'rafamadriz/friendly-snippets' },
}
require('luasnip').setup { history = true, delete_check_events = 'TextChanged' }

require('luasnip.loaders.from_vscode').lazy_load()
require('luasnip.loaders.from_vscode').lazy_load { paths = { vim.fn.stdpath 'config' .. '/snippets' } }

local extends = {
  typescript = { 'tsdoc' },
  javascript = { 'jsdoc' },
  lua = { 'luadoc' },
  python = { 'pydoc' },
  rust = { 'rustdoc' },
  cs = { 'csharpdoc' },
  java = { 'javadoc' },
  c = { 'cdoc' },
  cpp = { 'cppdoc' },
  php = { 'phpdoc' },
  kotlin = { 'kdoc' },
  ruby = { 'rdoc' },
  sh = { 'shelldoc' },
}
-- friendly-snippets - enable standardized comments snippets
for ft, snips in pairs(extends) do
  require('luasnip').filetype_extend(ft, snips)
end
add {
  source = 'Saghen/blink.cmp',
  checkout = 'v0.13.1',
  depends = {
    'mikavilpas/blink-ripgrep.nvim',
    'saghen/blink.compat',
  },
}

require('blink.cmp').setup {
  fuzzy = {
    prebuilt_binaries = {
      download = true,
      force_version = 'v0.13.1',
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
    nerd_font_variant = 'mono',
    kind_icons = vim.g.kind_icons,
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
        columns = { { 'kind_icon' }, { 'label', 'kind', 'source_name', gap = 1 } },
        align_to = 'none',
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
    preset = 'luasnip',
  },
  -- opts_extend = { 'sources.default' },
}
