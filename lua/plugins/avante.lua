return {
  'yetone/avante.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  build = 'make',
  version = false,
  opts = {
    ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
    provider = 'claude', -- Recommend using Claude
    auto_suggestions_provider = 'claude', -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
    claude = {
      endpoint = 'https://api.anthropic.com',
      model = 'claude-3-5-sonnet-20241022',
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
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'echasnovski/mini.icons', -- or echasnovski/mini.icons
    -- 'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
        behaviour = {
          auto_apply_diff_after_generation = true,
          support_paste_from_clipboard = true,
        },
      },
      keys = {
        {
          '<leader>mp',
          function()
            return vim.bo.filetype == 'AvanteInput' and require('avante.clipboard').paste_image() or require('img-clip').paste_image()
          end,
          desc = 'Paste Image',
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
