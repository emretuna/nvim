local add = MiniDeps.add

add {
  source = 'MeanderingProgrammer/render-markdown.nvim',
  depends = { 'nvim-treesitter/nvim-treesitter' },
}

require('render-markdown').setup {
  filetypes = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante' },
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
}
vim.keymap.set('n', '<leader>mr', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Render Markdown' })
