return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = 'VeryLazy',
  ft = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
  opts = {
    filetypes = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
    buf_ignore = {},
    code = {
      sign = false,
      width = 'block',
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = {},
    },
  },
  config = function(_, opts)
    require('render-markdown').setup(opts)
    vim.keymap.set('n', '<leader>mM', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Render Markdown' })
  end,
}
