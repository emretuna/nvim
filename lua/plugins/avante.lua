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
  ---@alias Mode "agentic" | "legacy"
  mode = 'agentic',
  -- auto_suggestions_provider = 'claude', -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
  providers = {
    ---@type AvanteSupportedProvider
    claude = {
      endpoint = 'https://api.anthropic.com',
      -- model = 'claude-3-5-sonnet-20241022',
      model = 'claude-3-7-sonnet-20250219',
      extra_request_body = {
        temperature = 0.75,
        max_tokens = 4096,
      },
    },
    ---@type AvanteSupportedProvider
    gemini = {
      endpoint = 'https://generativelanguage.googleapis.com/v1beta/models',
      model = 'gemini-2.0-flash',
      timeout = 30000, -- Timeout in milliseconds
      extra_request_body = {
        generationConfig = {
          temperature = 0.75,
        },
      },
    },
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
  -- Disable built-in tools to avoid conflicts with mcphub
  disabled_tools = {
    'list_files', -- Built-in file operations
    'search_files',
    'read_file',
    'create_file',
    'rename_file',
    'delete_file',
    'create_dir',
    'rename_dir',
    'delete_dir',
    'bash', -- Built-in terminal access
  },
  -- system_prompt as function ensures LLM always has latest MCP server state
  -- This is evaluated for every message, even in existing chats
  system_prompt = function()
    local hub = require('mcphub').get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ''
  end,
  -- Using function prevents requiring mcphub before it's loaded
  custom_tools = function()
    return {
      require('mcphub.extensions.avante').mcp_tool(),
    }
  end,
}

vim.keymap.set('n', '<leader>mp', function()
  require('avante.clipboard').paste_image()
end, {
  desc = 'Paste Image',
})

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
