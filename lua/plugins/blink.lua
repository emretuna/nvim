return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },
  enabled = false,
  -- use a release tag to download pre-built binaries
  version = 'v0.*',
  -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- On musl libc based systems you need to add this flag
  -- build = 'RUSTFLAGS="-C target-feature=-crt-static" cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    fuzzy = {
      prebuilt_binaries = {
        download = true,
        force_version = 'v0.8.1',
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
      keyword = { range = 'full' },
      accept = { auto_brackets = { enabled = false } },
      list = { selection = 'manual' },
      menu = {
        border = vim.g.border_style,
        winblend = vim.o.pumblend,
        draw = {
          columns = { { 'kind_icon' }, { 'label', 'kind', 'source_name', gap = 1 } },
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              -- Optionally, you may also use the highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
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
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'dadbod' },
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
    },
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
    local neocodeium = require 'neocodeium'
    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpCompletionMenuOpen',
      callback = function()
        neocodeium.clear()
      end,
    })
    vim.api.nvim_create_autocmd('User', {
      pattern = 'BlinkCmpCompletionMenuClose',
      callback = function()
        neocodeium.cycle_or_complete()
      end,
    })
  end,
}
