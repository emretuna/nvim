local add = MiniDeps.add

add {
  source = 'MeanderingProgrammer/render-markdown.nvim',
  depends = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
}

require('render-markdown').setup {
  file_types = { 'markdown', 'norg', 'rmd', 'org', 'vimwiki', 'Avante', 'opencode_output' },
  anti_conceal = { enabled = false },
  code = {
    sign = false,
    width = 'block',
    right_pad = 1,
    border = 'none',
    disable_background = true,
  },
  completions = {
    lsp = { enabled = true },
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
