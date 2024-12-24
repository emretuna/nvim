return {
  'NvChad/nvim-colorizer.lua',
  -- enabled = false,
  opts = {
    filetypes = {
      'css',
      'scss',
      'html',
      'javascript',
      'typescript',
      'typescriptreact',
      'lua',
      'json',
      cmp_docs = {
        always_update = true,
      },
      cmp_menu = {
        always_update = true,
      },
    },
    user_default_options = {
      -- Available modes for `mode`: foreground, background,  virtualtext
      mode = 'virtualtext',
      css = true,
      css_fn = true,
      tailwind = true,
      virtualtext = ' ',
    },
  },
  config = function(_, opts)
    require('colorizer').setup(opts)
  end,
}
