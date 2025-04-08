local add = MiniDeps.add

add {
  source = 'yetone/avante.nvim',
  monitor = 'main',
  depends = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'echasnovski/mini.pick',
    'MeanderingProgrammer/render-markdown.nvim',
    'echasnovski/mini.icons', -- or echasnovski/mini.icons
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
  -- auto_suggestions_provider = 'claude', -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
  claude = {
    endpoint = 'https://api.anthropic.com',
    model = 'claude-3-5-sonnet-20241022',
    -- model = 'claude-3-7-sonnet-20250219',
    temperature = 0,
    max_tokens = 4096,
  },
  windows = {
    sidebar_header = {
      rounded = false,
    },

    input = {
      prefix = '󱙺 ',
    },
  },
  file_selector = {
    provider = 'mini.pick',
  },
}

vim.keymap.set('n', '<leader>mp', function()
  require('avante.clipboard').paste_image()
end, {
  desc = 'Paste Image',
})
