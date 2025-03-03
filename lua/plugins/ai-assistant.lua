local add = MiniDeps.add
local ai_assistant = vim.g.ai_assistant or 'codeium' -- Default to neocodeium if not set

if ai_assistant == 'codeium' then
  add {
    source = 'monkoose/neocodeium',
  }

  local neocodeium = require 'neocodeium'
  neocodeium.setup {
    manual = false,
    show_label = true,
    silent = true,
    debounce = false,
  }

  -- Neocodeium keymaps
  vim.keymap.set('i', '<c-y>', function()
    neocodeium.accept()
  end)
  vim.keymap.set('i', '<c-w>', function()
    neocodeium.accept_word()
  end)
  vim.keymap.set('i', '<c-e>', function()
    neocodeium.accept_line()
  end)
  vim.keymap.set('i', '<c-p>', function()
    neocodeium.cycle_or_complete(-1)
  end)
  vim.keymap.set('i', '<c-n>', function()
    neocodeium.cycle_or_complete()
  end)
elseif ai_assistant == 'supermaven' then
  add {
    source = 'supermaven-inc/supermaven-nvim',
  }

  require('supermaven-nvim').setup {
    keymaps = {
      accept_suggestion = '<C-y>',
      accept_word = '<C-w>',
    },
    log_level = 'off',
    color = {
      suggestion_color = '#a6a69c',
    },
  }
else
  vim.notify('Error setting AI assistant: ' .. ai_assistant, vim.log.levels.WARN)
end
