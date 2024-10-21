return {
  'saghen/blink.cmp',
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = 'rafamadriz/friendly-snippets',
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
      use_nvim_cmp_as_default = false,
    },
    -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'normal',

    -- experimental auto-brackets support
    -- accept = { auto_brackets = { enabled = true } }

    -- experimental signature help support
    -- trigger = { signature_help = { enabled = true } },
    windows = {
      autocomplete = {
        border = 'rounded',
      },
      documentation = {
        border = 'rounded',
        auto_show = true,
      },
    },
    trigger = {
      signature_help = {
        enabled = true,
      },
    },
    keymap = {
      show = '<C-space>',
      hide = '<C-d>',
      accept = '<C-y>',
      select_prev = { '<Up>', '<C-p>' },
      select_next = { '<Down>', '<C-n>' },

      show_documentation = '<C-space>',
      hide_documentation = '<C-space>',
      scroll_documentation_up = '<C-b>',
      scroll_documentation_down = '<C-f>',

      snippet_forward = '<Tab>',
      snippet_backward = '<S-Tab>',
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
