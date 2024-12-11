return {
  'NvChad/nvim-colorizer.lua',
  -- enabled = false,
  opts = {
    filetypes = { 'css', 'scss', 'html', 'javascript', 'typescript', 'typescriptreact', 'lua', 'json' },
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
