return {
  'ahmedkhalf/project.nvim',
  cmd = 'ProjectRoot',
  event = 'VeryLazy',
  opts = {
    -- How to find root directory
    detection_methods = { 'pattern', 'lsp' },
    show_hidden = true, -- show hidden files in telescope
    --ignore_lsp = { "lua_ls" },
  },
  config = function(_, opts)
    require('project_nvim').setup(opts)
  end,
}
