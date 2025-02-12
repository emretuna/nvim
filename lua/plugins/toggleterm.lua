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

    -- Determine the correct command based on keychain availability
    local lazygit_cmd = vim.fn.executable 'keychain' == 1 and "bash -c 'eval $(keychain --eval ~/.ssh/github.key) && lazygit'" or 'lazygit'

    -- LazyGit terminal instance
    local lazygit = Terminal:new {
      cmd = lazygit_cmd,
      hidden = true,
      direction = 'float',
      close_on_exit = true,
      on_open = function()
        vim.cmd 'startinsert!'
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
