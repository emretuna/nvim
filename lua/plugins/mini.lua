return {
  {
    'echasnovski/mini.base16',
    lazy = false,
    priority = 1000,
    config = function()
      -- Define dark and light palettes
      local dark_palette = {
        base00 = '#171717', -- Darkest background
        base01 = '#1e1e1e', -- Slightly lighter for contrast
        base02 = '#262626', -- Mid dark for UI elements
        base03 = '#303030', -- Comments and subtle text
        base04 = '#424242', -- Midtone for inactive elements
        base05 = '#646464', -- Default text, standard readability
        base06 = '#909090', -- Slightly lighter text for emphasis
        base07 = '#c8c8c8', -- Lightest text, headings
        base08 = '#a37b6f', -- Variables, markup link text
        base09 = '#DEEEED', -- Integers, booleans, constants
        base0A = '#708090', -- Classes, markup bold
        base0B = '#505050', -- Strings, markup code
        base0C = '#6a6a6a', -- Support, diff changed
        base0D = '#a8a8a8', -- Functions, methods
        base0E = '#5e5e5e', -- Keywords, storage
        base0F = '#404040', -- Deprecated, special tags
      }

      local light_palette = {
        base00 = '#fafafa', -- Softest light background
        base01 = '#f0f0f0', -- Slightly darker for subtle contrast
        base02 = '#e6e6e6', -- Mid light for UI elements
        base03 = '#dcdcdc', -- Comments and subtle text
        base04 = '#c0c0c0', -- Inactive elements with soft contrast
        base05 = '#808080', -- Default text, balanced readability
        base06 = '#5c5c5c', -- Slightly darker text for emphasis
        base07 = '#2f2f2f', -- Darkest text, headings
        base08 = '#a08070', -- Variables, markup link text (muted warm tone)
        base09 = '#728c7b', -- Integers, booleans, constants (soft green)
        base0A = '#708090', -- Classes, markup bold (cool muted blue-gray)
        base0B = '#6e6e6e', -- Strings, markup code (neutral and soft)
        base0C = '#8a8a8a', -- Support, diff changed (gentle gray tone)
        base0D = '#505050', -- Functions, methods (subtle dark gray)
        base0E = '#686868', -- Keywords, storage (medium contrast gray)
        base0F = '#909090', -- Deprecated, special tags (muted and neutral)
      }

      -- Function to apply the colorscheme based on `vim.o.background`
      local function apply_palette()
        local palette = vim.o.background == 'dark' and dark_palette or light_palette
        require('mini.base16').setup {
          palette = palette,
          use_cterm = true,
        }
        vim.g.colors_name = 'base16' -- Set colorscheme name
      end

      -- Apply the palette during initialization
      apply_palette()

      -- Set up an autocmd to change the palette dynamically
      vim.api.nvim_create_autocmd('OptionSet', {
        pattern = 'background',
        callback = function()
          apply_palette()
        end,
      })
    end,
  },
  {
    'echasnovski/mini.basics',
    -- enabled = false,
    lazy = false,
    opts = {
      options = {
        win_border = 'single',
        extra_ui = false,
      },
      mappings = {
        move_with_alt = true,
        option_toggle_prefix = [[\]],
      },

      autocommands = {
        relnum_in_visual_mode = true,
      },
    },
    config = function(_, opts)
      require('mini.basics').setup(opts)
    end,
  },
  {
    'echasnovski/mini.visits',
    event = 'VeryLazy',
    config = function()
      require('mini.visits').setup()
      vim.keymap.set('n', '<leader>va', function()
        MiniVisits.add_label()
      end, { desc = 'Add Visit' })
      vim.keymap.set('n', '<leader>vd', function()
        MiniVisits.remove_label()
      end, { desc = 'Delete Visit' })
    end,
  },
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
    'echasnovski/mini.pick',
    opts = {
      options = {
        content_from_bottom = false,
      },
      window = {
        prompt_prefix = ' ❯ ',
        config = {
          border = vim.g.border_style,
        },
      },
      mappings = {
        marked_to_quickfix = {
          char = '<C-q>',
          func = function()
            local items = MiniPick.get_picker_matches().marked or {}
            MiniPick.default_choose_marked(items)
            MiniPick.stop()
          end,
        },
        all_to_quickfix = {
          char = '<A-q>',
          func = function()
            local matched_items = MiniPick.get_picker_matches().all or {}
            MiniPick.default_choose_marked(matched_items)
            MiniPick.stop()
          end,
        },
      },
    },
    config = function(_, opts)
      require('mini.pick').setup(opts)
      vim.keymap.set('n', '<leader>f.', function()
        MiniPick.builtin.files()
      end, { desc = 'Search Files' })

      vim.keymap.set('n', '<leader>f/', function()
        MiniPick.builtin.grep_live()
      end, { desc = 'Search with Live Grep' })

      vim.keymap.set('n', '<leader>fo', function()
        MiniExtra.pickers.oldfiles()
      end, { desc = 'Search Oldfiles' })

      vim.keymap.set('n', '<leader>fg', function()
        MiniExtra.pickers.git_files()
      end, { desc = 'Search Git files' })

      vim.keymap.set('n', '<leader>fc', function()
        MiniPick.builtin.grep { pattern = vim.fn.expand '<cword>' }
      end, { desc = 'Grep Current Word' })

      vim.keymap.set('n', '<leader>fw', function()
        MiniPick.builtin.grep()
      end, { desc = 'Search Word' })

      vim.keymap.set('n', '<leader>fr', function()
        MiniPick.builtin.resume()
      end, { desc = 'Search Resume' })

      vim.keymap.set('n', '<leader>fK', function()
        MiniExtra.pickers.keymaps()
      end, { desc = 'Search Keymaps' })

      vim.keymap.set('n', '<leader>fC', function()
        MiniExtra.pickers.commands()
      end, { desc = 'Search Commands' })

      vim.keymap.set('n', '<leader>fd', function()
        MiniExtra.pickers.diagnostic()
      end, { desc = 'Search Diagnostics' })

      vim.keymap.set('n', '<leader>b.', function()
        MiniPick.builtin.buffers()
      end, { desc = 'Find Buffers' })

      vim.keymap.set('n', '<leader>fH', function()
        MiniPick.builtin.help({}, {
          source = {
            name = ' Help  ',
          },
          options = {
            content_from_bottom = false,
          },
          window = {
            config = {
              height = math.floor(0.35 * vim.o.lines),
              width = vim.api.nvim_win_get_width(0),
            },
          },
        })
      end, { desc = 'Search Help' })

      vim.keymap.set('n', '<leader>fb', function()
        MiniExtra.pickers.buf_lines({ scope = 'current', preserve_order = true }, {
          source = {
            name = ' Grep Buffer ',
          },
          options = {
            content_from_bottom = false,
          },
          window = {
            config = {
              height = math.floor(0.35 * vim.o.lines),
              width = vim.api.nvim_win_get_width(0),
            },
          },
        })
      end, { desc = 'Grep in Buffer' })

      vim.keymap.set('n', '<leader>fN', function()
        MiniPick.builtin.files({}, {
          source = {
            name = 'Neovim Config',
            cwd = vim.fn.stdpath 'config',
          },
        })
      end, { desc = 'Search Nvim Config' })

      vim.keymap.set('n', '<leader>fD', function()
        MiniExtra.pickers.explorer {
          cwd = os.getenv 'HOME' .. '/.dotfiles',
        }
      end, { desc = 'Search Dotfiles' })

      vim.keymap.set('n', '<leader>fP', function()
        MiniExtra.pickers.explorer {
          cwd = os.getenv 'HOME' .. '/Code',
        }
      end, { desc = 'Search Projects' })

      vim.keymap.set('n', '<leader>ft', function()
        local colorscheme = MiniPick.start {
          source = {
            name = ' Colorscheme ',
            items = vim.fn.getcompletion('', 'color'),
          },
        }
        if colorscheme ~= nil then
          vim.cmd('colorscheme ' .. colorscheme)
        end
      end, { desc = 'Search Themes/Colorscheme' })

      vim.keymap.set('n', '<leader>gC', function()
        local git_commands = MiniPick.start {
          source = {
            name = ' Git ',
            items = vim.fn.getcompletion('Git ', 'cmdline'),
          },
        }
        if git_commands ~= nil then
          vim.cmd('Git ' .. git_commands)
        end
      end, { desc = 'Search Git Commands' })

      vim.keymap.set('n', '<leader>gb', function()
        MiniExtra.pickers.git_branches()
      end, { desc = 'Search Git Branches' })

      vim.keymap.set('n', '<leader>gc', function()
        MiniExtra.pickers.git_commits()
      end, { desc = 'Search Git Commits' })

      vim.keymap.set('n', '<leader>fh', function()
        MiniExtra.pickers.git_hunks()
      end, { desc = 'Search Git Hunks' })

      vim.keymap.set('n', '<leader>fs', function()
        MiniExtra.pickers.lsp { scope = 'document_symbol' }
      end, { desc = 'Search Document Symbol' })

      vim.keymap.set('n', '<leader>fm', function()
        MiniExtra.pickers.marks()
      end, { desc = 'Search Marks' })

      vim.keymap.set('n', '<leader>fr', function()
        MiniExtra.pickers.registers()
      end, { desc = 'Search Registers' })

      vim.keymap.set('n', '<leader>fp', function()
        local builtin = MiniPick.start {
          source = {
            name = ' Pick ',
            items = vim.fn.getcompletion('Pick ', 'cmdline'),
          },
        }
        if builtin ~= nil then
          vim.cmd('Pick ' .. builtin)
        end
      end, { desc = 'Search Builtin Pick Commands' })

      -- Only works with lazy
      vim.keymap.set('n', '<leader>mr', function()
        local plugin = MiniPick.start {
          source = {
            name = ' Reload Plugins ',
            items = require('config.utils').pluginNames(),
          },
        }
        if plugin ~= nil then
          vim.cmd('Lazy reload ' .. plugin)
        end
      end, { desc = 'Pick plugins to reload' })
      -- Visits keymap
      vim.keymap.set('n', '<leader>vl', function()
        MiniExtra.pickers.visit_labels()
      end, { desc = 'Visit Labels' })
      vim.keymap.set('n', '<leader>vp', function()
        MiniExtra.pickers.visit_paths()
      end, { desc = 'Visit Paths' })
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
        go_in = '<S-Enter>',
        go_in_plus = '<Enter>',
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
  {
    'echasnovski/mini.extra',
    event = 'VeryLazy',
    config = function()
      require('mini.extra').setup()
    end,
  },
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
      vim.keymap.set({ 'n', 'x' }, '<Leader>gd', '<CMD>lua MiniGit.show_diff_source()<CR>', { desc = 'Show diff source' })
      vim.keymap.set({ 'n', 'x' }, '<Leader>gh', '<CMD>lua MiniGit.show_range_history()<CR>', { desc = 'Show range history' })
    end,
  },
  {
    'echasnovski/mini.statusline',
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
            local macro = vim.g.macro_recording
            return MiniStatusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
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
