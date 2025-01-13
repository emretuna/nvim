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
      accept_suggestion = '<C-y>',
      accept_word = '<C-w>',
    },
    log_level = 'off',
    color = {
      suggestion_color = '#a6a69c',
    },
  },
  config = function(_, opts)
    require('supermaven-nvim').setup(opts)
  end,
}
