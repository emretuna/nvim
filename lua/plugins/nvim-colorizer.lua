return {
  'NvChad/nvim-colorizer.lua',
  opts = {
    filetypes = { 'css', 'scss', 'html', 'javascript', 'typescript', 'typescriptreact', 'lua', 'json' },
    user_default_options = {
      -- Available modes for `mode`: foreground, background,  virtualtext
      mode = 'virtualtext',
      tailwind = true,
      virtualtext = '⬤ ',
    },
  },
  config = function(_, opts)
    require('colorizer').setup(opts)
  end,
}
