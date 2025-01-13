return {
  'monkoose/neocodeium',
  enabled = vim.g.ai_assistant == 'codeium',
  lazy = true,
  opts = {
    manual = false,
    show_label = true,
    silent = true,
    debounce = false,
  },
  config = function(_, opts)
    local neocodeium = require 'neocodeium'
    neocodeium.setup(opts)
    vim.keymap.set('i', '<c-y>', function()
      require('neocodeium').accept()
    end)
    vim.keymap.set('i', '<c-w>', function()
      require('neocodeium').accept_word()
    end)
    vim.keymap.set('i', '<c-e>', function()
      require('neocodeium').accept_line()
    end)
    vim.keymap.set('i', '<c-p>', function()
      require('neocodeium').cycle_or_complete(-1)
    end)
    vim.keymap.set('i', '<c-n>', function()
      require('neocodeium').cycle_or_complete()
    end)
  end,
}
