require('avante').setup {
  ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
  provider = 'claude', -- Recommend using Claude
  -- auto_suggestions_provider = 'claude', -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
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
}
