return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = 'VeryLazy',
  ft = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki' },
  -- enabled = false,
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    filetypes = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki' },
    buf_ignore = { 'nofile' },
    code = {
      sign = false,
      width = 'block',
      right_pad = 1,
      border = 'none',
      disable_background = true,
    },
    latex = {
      enabled = false,
    },
    heading = {
      sign = false,
      icons = {},
    },
  },
  config = function(_, opts)
    require('render-markdown').setup(opts)
    vim.keymap.set('n', '<leader>mr', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Render Markdown' })
  end,
}
