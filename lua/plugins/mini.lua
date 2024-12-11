return {
  {
    'echasnovski/mini.bufremove',
    event = 'VeryLazy',
    opts = {
      set_vim_settings = false,
    },
    config = function()
      require('mini.bufremove').setup()
      -- Function to remove all buffers except the current one
      local function remove_all_but_current()
        local current_buf = vim.api.nvim_get_current_buf() -- Get the current buffer ID
        local buffers = vim.api.nvim_list_bufs() -- Get a list of all buffer IDs

        for _, buf_id in ipairs(buffers) do
          -- Only delete the buffer if it's not the current one
          if buf_id ~= current_buf then
            -- Use MiniBufremove.delete to delete the buffer
            local success = require('mini.bufremove').delete(buf_id, false) -- true = force delete
            if not success then
              print('Failed to delete buffer:', buf_id)
            end
          end
        end
      end

      vim.keymap.set('n', '<leader>bx', '<cmd>lua MiniBufremove.delete()<CR>', { desc = 'Delete Buffer' })
      vim.keymap.set('n', '<leader>bw', '<cmd>lua MiniBufremove.wipeout()<CR>', { desc = 'Wipeout Buffer' })
      vim.keymap.set('n', '<leader>bc', function()
        remove_all_but_current()
      end, { desc = 'Delete All Buffers' })
    end,
  },
  {
    'echasnovski/mini.files',
    event = 'VeryLazy',
    opts = {
      options = {
        permanent_delete = false,
      },
      mappings = {
        go_in = 'L',
        go_in_plus = 'l',
        synchronize = '<C-s>',
      },
      border = vim.g.border_style,
    },
    config = function(_, opts)
      require('mini.files').setup(opts)
      vim.keymap.set('n', '_', '<CMD>lua MiniFiles.open()<CR>', { desc = 'Mini Files' })
      vim.keymap.set('n', '-', '<CMD>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', { desc = 'Mini Files' })
      vim.api.nvim_create_autocmd('User', {
        pattern = { 'MiniFilesWindowOpen', 'MiniFilesWindowUpdate' },
        callback = function(args)
          local win_id = args.data.win_id

          -- Customize window-local settings
          local config = vim.api.nvim_win_get_config(win_id)
          config.border = vim.g.border_style
          -- Make window full height to make it look TUI File manager
          -- config.height = vim.o.lines
          vim.api.nvim_win_set_config(win_id, config)
        end,
      })
    end,
  },
  {
    'echasnovski/mini.icons',
    event = 'VeryLazy',
    opts = {
      extension = {
        ['http'] = { glyph = '󰖟', hl = 'MiniIconsGreen' },
        ['rest'] = { glyph = '󱂛', hl = 'MiniIconsBlue' },
        ['.eslintrc.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
        ['.node-version'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['.prettierrc'] = { glyph = '', hl = 'MiniIconsPurple' },
        ['.yarnrc.yml'] = { glyph = '', hl = 'MiniIconsBlue' },
        ['eslint.config.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
        ['package.json'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['tsconfig.build.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['yarn.lock'] = { glyph = '', hl = 'MiniIconsBlue' },
      },
    },
    config = function()
      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
  {
    'echasnovski/mini.hipatterns',
    event = 'VeryLazy',
    opts = function()
      return {
        highlighters = {
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
          todo = require('mini.extra').gen_highlighter.words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
          hack = require('mini.extra').gen_highlighter.words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
          note = require('mini.extra').gen_highlighter.words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
          fixme = require('mini.extra').gen_highlighter.words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
        },
      }
    end,
    config = function(_, opts)
      require('mini.hipatterns').setup(opts)
    end,
  },
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
          '',
          'Trouble',
          'alpha',
          'avante',
          'dashboard',
          'fzf',
          'help',
          'lazy',
          'lspinfo',
          'man',
          'mason',
          'minifiles',
          'neo-tree',
          'nofile',
          'notify',
          'noice',
          'netrw',
          'oil',
          'oil_preview',
          'toggleterm',
          'trouble',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require('mini.indentscope').setup {
        symbol = '╎', --  ╎ │
        options = { try_as_border = true },
      }
    end,
  },
  { 'echasnovski/mini.tabline', event = 'VimEnter', opts = { show_icons = true } },
  { 'echasnovski/mini.extra', event = 'VeryLazy' },
  {
    'echasnovski/mini.ai',
    event = 'BufReadPost',
    opts = function()
      return {
        mappings = {
          around = 'a',
          inside = 'i',

          around_next = 'an',
          inside_next = 'in',
          around_last = 'al',
          inside_last = 'il',

          goto_left = 'g[',
          goto_right = 'g]',
        },
        n_lines = 500,
        custom_textobjects = {
          B = require('mini.extra').gen_ai_spec.buffer(),
          D = require('mini.extra').gen_ai_spec.diagnostic(),
          I = require('mini.extra').gen_ai_spec.indent(),
          L = require('mini.extra').gen_ai_spec.line(),
          N = require('mini.extra').gen_ai_spec.number(),
          o = require('mini.ai').gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          u = require('mini.ai').gen_spec.function_call(), -- u for "Usage"
          U = require('mini.ai').gen_spec.function_call { name_pattern = '[%w_]' }, -- without dot in function name
          f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
          d = { '%f[%d]%d+' }, -- digits
          e = { -- Word with case
            {
              '%u[%l%d]+%f[^%l%d]',
              '%f[%S][%l%d]+%f[^%l%d]',
              '%f[%P][%l%d]+%f[^%l%d]',
              '^[%l%d]+%f[^%l%d]',
            },
            '^().*()$',
          },
          g = function() -- Whole buffer, similar to `gg` and 'G' motion
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line '$',
              col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
      }
    end,
    config = function(_, opts)
      require('mini.ai').setup(opts)
    end,
  },
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
    'echasnovski/mini.diff',
    event = 'BufReadPost',
    opts = {
      view = {
        style = 'sign',
        signs = { add = '+', change = '~', delete = '-' },
      },
    },
  },
  {
    'echasnovski/mini-git',
    config = function()
      require('mini.git').setup()
      vim.keymap.set({ 'n', 'x' }, '<Leader>gs', '<CMD>lua MiniGit.show_at_cursor()<CR>', { desc = 'Show at cursor' })
    end,
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
            local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
            local git = MiniStatusline.section_git { trunc_width = 75 }
            local diff = MiniStatusline.section_diff { trunc_width = 75 }
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
            local location = MiniStatusline.section_location { trunc_width = 75 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }
            local arrow = require('arrow.statusline').text_for_statusline_with_icons()
            local macro = vim.g.macro_recording
            return MiniStatusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, arrow } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFilename', strings = { macro } },
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
