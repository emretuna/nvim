local add = MiniDeps.add

add {
  source = 'folke/zen-mode.nvim',
  depends = {
    'folke/twilight.nvim',
  },
}

require('zen-mode').setup {
  plugins = {
    twilight = {
      enabled = true,
    },
  },
  window = {
    options = {
      signcolumn = 'no', -- disable signcolumn
      number = false, -- disable number column
      relativenumber = false, -- disable relative numbers
      cursorline = false, -- disable cursorline
      cursorcolumn = false, -- disable cursor column
      foldcolumn = '0', -- disable fold column
      list = false, -- disable whitespace characters
    },
  },
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
}

require('twilight').setup()
vim.keymap.set('n', '<leader>ut', ':Twilight<cr>', { desc = 'Twilight' })
vim.keymap.set('n', '<leader>uz', ':ZenMode<cr>', { desc = 'Zen Mode' })
