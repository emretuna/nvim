local add = MiniDeps.add

add {
  source = 'Saghen/blink.cmp',
  depends = {
    'mikavilpas/blink-ripgrep.nvim',
    'rafamadriz/friendly-snippets',
    'MeanderingProgrammer/render-markdown.nvim',
  },
  hooks = {
    post_install = function(params)
      vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
    end,
    post_checkout = function(params)
      vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
    end,
  },
}

require('blink.cmp').setup {
  fuzzy = { implementation = 'prefer_rust_with_warning' },

  keymap = {
    preset = 'default',
    ['<Tab>'] = {
      'snippet_forward',
      function() -- sidekick next edit suggestion
        return require('sidekick').nes_jump_or_apply()
      end,
      function() -- if you are using Neovim's native inline completions
        return vim.lsp.inline_completion.get()
      end,
      'fallback',
    },
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
    default = { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'markdown' },
    min_keyword_length = 0,
    per_filetype = { sql = { 'dadbod', 'lsp' } },
    providers = {
      ripgrep = {
        module = 'blink-ripgrep',
        name = 'Ripgrep',
        ---@module "blink-ripgrep"
        ---@type blink-ripgrep.Options
        opts = {
          prefix_min_len = 4,
          score_offset = 10, -- should be lower priority
        },
        backend = {
          ripgrep = {
            max_filesize = '300K',
            search_casing = '--smart-case',
          },
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
