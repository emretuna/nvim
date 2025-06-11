local add = MiniDeps.add

add {
  source = 'ravitemer/mcphub.nvim',
  depends = {
    'nvim-lua/plenary.nvim',
  },
  hooks = {
    post_install = function()
      vim.fn.system 'npm install -g mcp-hub@latest'
    end,
  },
}

require('mcphub').setup {
  auto_approve = true,
  extensions = {
    avante = {
      make_slash_commands = true, -- make /slash commands from MCP server prompts
    },
  },
  ui = {
    window = {
      border = vim.g.border_style, -- "none", "single", "double", "rounded", "solid", "shadow"
    },
  },
}
