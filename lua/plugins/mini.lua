return {
  {
    'echasnovski/mini.misc',
    lazy = false,
    config = function()
      require('mini.misc').setup()
      require('mini.misc').setup_restore_cursor()
      require('mini.misc').setup_auto_root()
    end,
  },
  {
    'echasnovski/mini.bracketed',
    event = 'VeryLazy',
    config = function()
      require('mini.bracketed').setup()
    end,
  },
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { 'string' },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      require('mini.pairs').setup(opts)
    end,
  },
  {
    'echasnovski/mini.splitjoin',
    config = function()
      require('mini.splitjoin').setup {
        mappings = {
          toggle = 'gS',
        },
      }
    end,
  },
  {
    'echasnovski/mini.indentscope',
    event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require('mini.indentscope').setup {
        symbol = '│',
        options = { try_as_border = true },
      }
    end,
  },
  { 'echasnovski/mini.tabline', event = 'VimEnter', opts = { show_icons = true } },
  { 'echasnovski/mini.ai', event = 'BufReadPost', opts = { n_lines = 500 } },
  { 'echasnovski/mini.surround', event = 'BufReadPost', opts = {} },
  {
    'echasnovski/mini.animate',
    event = 'VeryLazy',
    opts = function()
      -- don't use animate when scrolling with the mouse
      local mouse_scrolled = false
      for _, scroll in ipairs { 'Up', 'Down' } do
        local key = '<ScrollWheel' .. scroll .. '>'
        vim.keymap.set({ '', 'i' }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require 'mini.animate'
      return {
        open = { enable = false }, -- true causes issues on nvim-spectre
        resize = {
          timing = animate.gen_timing.linear { duration = 33, unit = 'total' },
        },
        scroll = {
          timing = animate.gen_timing.linear { duration = 50, unit = 'total' },
          subscroll = animate.gen_subscroll.equal {
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          },
        },
        cursor = {
          enable = false, -- We don't want cursor ghosting
          timing = animate.gen_timing.linear { duration = 26, unit = 'total' },
        },
      }
    end,
    config = function(_, opts)
      require('mini.animate').setup(opts)
    end,
  },
  {
    'echasnovski/mini.move',
    event = 'BufReadPost',
    config = true,
  },
  {
    'echasnovski/mini.statusline',
    dependencies = {
      'otavioschwanck/arrow.nvim',
    },
    event = 'VeryLazy',
    opts = function()
      return {
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local MiniStatusline = require 'mini.statusline'
            local blocked_filetypes = { ['neo-tree'] = true, ['avante'] = true }
            if blocked_filetypes[vim.bo.filetype] then
              vim.cmd 'highlight StatusLine guibg=NONE guifg=NONE'
              return ''
            end
            local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
            local git = MiniStatusline.section_git { trunc_width = 75 }
            local diff = MiniStatusline.section_diff { trunc_width = 75 }
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
            local location = MiniStatusline.section_location { trunc_width = 75 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }
            local arrow = require('arrow.statusline').text_for_statusline_with_icons()

            return MiniStatusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, arrow } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            }
          end,
        },
      }
    end,
    config = function(_, opts)
      require('mini.statusline').setup(opts)
    end,
  },
}
