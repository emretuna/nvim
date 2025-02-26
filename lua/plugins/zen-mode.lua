return {
  'folke/zen-mode.nvim',
  -- enabled = false,
  event = 'VeryLazy',
  dependencies = {
    {
      'folke/twilight.nvim',
      config = function()
        require('twilight').setup()
        vim.keymap.set('n', '<leader>ut', '<cmd>Twilight<cr>', { desc = 'Twilight' })
      end,
    },
  },
  opts = {
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
  },
  config = function(_, opts)
    require('zen-mode').setup(opts)

    vim.keymap.set('n', '<leader>uz', ':ZenMode<cr>', { desc = 'Zen Mode' })
  end,
}
