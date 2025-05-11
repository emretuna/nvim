local add = MiniDeps.add

add {
  source = 'yetone/avante.nvim',
  monitor = 'main',
  depends = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    -- 'zbirenbaum/copilot.lua', -- for providers='copilot'
  },
  hooks = {
    post_checkout = function()
      vim.cmd 'AvanteBuild'
    end,
  },
}

require('avante').setup {
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  provider = 'claude', -- Recommend using Claude
  mode = 'legacy',
  -- auto_suggestions_provider = 'claude', -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
  claude = {
    endpoint = 'https://api.anthropic.com',
    model = 'claude-3-5-sonnet-20241022',
    -- model = 'claude-3-7-sonnet-20250219',
    temperature = 0,
    max_tokens = 4096,
  },
  web_search_engine = {
    provider = 'tavily',
  },
  windows = {
    sidebar_header = {
      rounded = false,
    },
    input = {
      prefix = '󱙺 ',
    },
    edit = {
      border = vim.g.border_style,
      start_insert = true, -- Start insert mode when opening the edit window
    },
    ask = {
      border = vim.g.border_style,
      start_insert = true, -- Start insert mode when opening the ask window
    },
  },
}

vim.keymap.set('n', '<leader>mp', function()
  require('avante.clipboard').paste_image()
end, {
  desc = 'Paste Image',
})

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
