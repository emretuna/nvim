require('mini.pick').setup {
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
}
vim.ui.select = MiniPick.ui_select

MiniPick.registry.buffers = function(local_opts)
  local wipeout_buffer = function()
    MiniBufremove.delete(MiniPick.get_picker_matches().current.bufnr, false)
  end
  MiniPick.builtin.buffers(local_opts, { mappings = { wipeout = { char = '<C-d>', func = wipeout_buffer } } })
end

vim.keymap.set('n', '<leader>f.', function()
  MiniPick.builtin.files()
end, { desc = 'Search Files' })

vim.keymap.set('n', '<leader>ff', function()
  MiniExtra.pickers.explorer()
end, { desc = 'File Explorer' })

vim.keymap.set('n', '<leader>f/', function()
  MiniPick.builtin.grep_live()
end, { desc = 'Search with Live Grep' })

vim.keymap.set('n', '<leader>f?', function()
  MiniExtra.pickers.hipatterns()
end, { desc = 'Search Hipatterns' })

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
  MiniPick.registry.buffers { include_current = false }
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
vim.keymap.set('n', '<leader>fT', function()
  MiniExtra.pickers.explorer {
    cwd = os.getenv 'HOME' .. '/.local/share/nvim/mini.files/trash',
  }
end, { desc = 'Search Trash' })
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

vim.keymap.set('n', '<leader>gB', function()
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

vim.keymap.set('n', '<leader>fn', function()
  MiniNotify.show_history()
end, { desc = 'Show Notifications' })

vim.keymap.set('n', '<leader>fR', function()
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

-- Visits keymap
vim.keymap.set('n', '<leader>vl', function()
  MiniExtra.pickers.visit_labels()
end, { desc = 'Visit Labels' })
vim.keymap.set('n', '<leader>vp', function()
  MiniExtra.pickers.visit_paths()
end, { desc = 'Visit Paths' })
vim.keymap.set('n', '<leader>fS', function()
  MiniSessions.select()
end, { desc = 'Select Session' })
