return {
  'akinsho/toggleterm.nvim',
  -- enabled = false,
  event = 'VeryLazy',
  cmd = { 'ToggleTerm', 'TermExec' },
  opts = {
    highlights = {
      Normal = { link = 'Normal' },
      NormalNC = { link = 'NormalNC' },
      NormalFloat = { link = 'Normal' },
      FloatBorder = { link = 'FloatBorder' },
      StatusLine = { link = 'StatusLine' },
      StatusLineNC = { link = 'StatusLineNC' },
      WinBar = { link = 'WinBar' },
      WinBarNC = { link = 'WinBarNC' },
    },
    size = 10,
    open_mapping = [[<c-\>]],
    shading_factor = 2,
    direction = 'float',
    float_opts = {
      border = vim.g.border_style,
      highlights = { border = 'Normal', background = 'Normal' },
    },
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)
    local Terminal = require('toggleterm.terminal').Terminal

    vim.keymap.set('n', '<F7>', '<cmd>ToggleTerm direction=horizontal<cr>', { desc = 'Toggle Terminal' })
    vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Exit Terminal Mode' })
    vim.keymap.set('t', '<C-\\>', '<cmd>close<cr>', { desc = 'Hide Terminal' })

    -- LazyGit configuration
    local function get_lazygit_cmd()
      local config_path = vim.fn.expand(vim.fn.stdpath 'cache' .. '/lazygit-theme.yml')
      local config_arg = string.format('--use-config-file="%s"', config_path)

      local has_keychain = vim.fn.executable 'keychain' == 1
      if has_keychain then
        return string.format("bash -c 'eval $(keychain --eval ~/.ssh/github.key) && lazygit %s'", config_arg)
      end

      return string.format('lazygit %s', config_arg)
    end

    local lazygit_cmd = get_lazygit_cmd()

    -- LazyGit terminal instance
    local lazygit = Terminal:new {
      cmd = lazygit_cmd,
      hidden = true,
      direction = 'float',
      close_on_exit = true,
      float_opts = {
        border = vim.g.border_style,
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.9)
        end,
      },
      on_open = function(_)
        vim.cmd 'startinsert!'
        -- Set up terminal buffer-local options
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.foldcolumn = '0'
        vim.opt_local.statuscolumn = ''
      end,
      on_exit = function(_)
        vim.cmd 'startinsert!'
        -- Refresh buffers when lazygit exits
        vim.cmd 'checktime'
      end,
    }

    -- Toggle LazyGit only if inside a Git repository
    vim.keymap.set('n', '<leader>g.', function()
      if vim.fn.finddir('.git', vim.fn.getcwd() .. ';') ~= '' then
        lazygit:toggle()
      else
        vim.notify('Not a git repository', vim.log.levels.WARN)
      end
    end, { desc = 'Toggle LazyGit' })
  end,
}
