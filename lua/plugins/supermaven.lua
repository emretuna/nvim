return {
  'supermaven-inc/supermaven-nvim',
  event = 'InsertEnter',
  enabled = vim.g.ai_assistant == 'supermaven',
  lazy = true,
  cmd = {
    'SupermavenUseFree',
    'SupermavenUsePro',
  },
  opts = {
    keymaps = {
      accept_suggestion = '<C-j>',
      accept_word = '<C-w>',
    },
    color = {
      suggestion_color = '#a6a69c',
    },
  },
  config = function(_, opts)
    require('supermaven-nvim').setup(opts)
  end,
}
