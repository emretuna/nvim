return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets', 'mikavilpas/blink-ripgrep.nvim' },
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
    highlight = {
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release, assuming themes add support
      use_nvim_cmp_as_default = true,
    },
    -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',

    -- experimental auto-brackets support
    -- accept = { auto_brackets = { enabled = true } }

    windows = {
      completion = {
        menu = {
          border = vim.g.border_style,
          winblend = vim.o.pumblend,
        },
      },
      autocomplete = {
        border = vim.g.border_style,
        draw = 'minimal',
        winblend = vim.o.pumblend,
      },

      documentation = {
        border = vim.g.border_style,
        auto_show = true,
        winblend = vim.o.pumblend,
      },
      signature_help = {
        border = vim.g.border_style,
        winblend = vim.o.pumblend,
      },
      ghost_text = {
        enabled = false,
      },
    },
    -- experimental signature help support
    trigger = {
      signature_help = {
        enabled = false,
      },
    },
    -- experimental auto-brackets support
    accept = { auto_brackets = { enabled = true } },

    sources = {
      -- adding any nvim-cmp sources here will enable them
      -- with blink.compat
      compat = {},
      completion = {
        -- remember to enable your providers here
        enabled_providers = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'ripgrep', 'dadbod' },
      },
    },
    providers = {
      path = {
        name = 'path',
        score_offset = 100,
      },
      lsp = {
        name = 'lsp',
        score_offset = 99,
      },
      lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
      ripgrep = {
        module = 'blink-ripgrep',
        name = 'Ripgrep',
        ---@module "blink-ripgrep"
        ---@type blink-ripgrep.Options
        opts = {
          get_command = function(_, prefix)
            local root = require('my-nvim-micro-plugins.main').find_project_root()
            return {
              'rg',
              '--no-config',
              '--json',
              '--word-regexp',
              '--ignore-case',
              '--',
              prefix .. '[\\w_-]+',
              root or vim.fn.getcwd(),
            }
          end,
        },
      },
      dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
    },
    keymap = {
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-d>'] = { 'hide' },
      ['<C-y>'] = { 'select_and_accept', 'fallback' },

      ['<C-p>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'select_next', 'fallback' },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },

      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

      ['<Tab>'] = { 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    },
  },
  config = function(_, opts)
    require('blink.cmp').setup(opts)
    local cmp = require 'blink.cmp'
    local neocodeium = require 'neocodeium.commands'
    local commands = require 'neocodeium.commands'
    if cmp.windows and cmp.windows.autocomplete then
      cmp.on_open(function()
        neocodeium.clear() -- Call neocodeium.clear when autocomplete opens
      end)

      cmp.on_close(function()
        commands.enable() -- Enable commands when autocomplete closes
        neocodeium.cycle_or_complete() -- Trigger neocodeium's cycle or complete logic
      end)
    end
  end,
}
