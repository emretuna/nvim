local add = MiniDeps.add

add {
  source = 'L3MON4D3/LuaSnip',
  checkout = 'v2.*',
  post_checkout = function()
    vim.cmd 'make install_jsregexp'
  end,
  depends = {
    'rafamadriz/friendly-snippets',
  },
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
    'rafamadriz/friendly-snippets',
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
      selection = { preselect = true, auto_insert = true },
    },
    accept = { auto_brackets = { enabled = true } },
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
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'markdown' },
    min_keyword_length = 0,
    providers = {
      lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100, fallbacks = { 'lsp' } },
      markdown = { name = 'RenderMarkdown', module = 'render-markdown.integ.blink', fallbacks = { 'lsp' } },
    },
  },

  snippets = {
    preset = 'luasnip',
  },
  -- opts_extend = { 'sources.default' },
}
