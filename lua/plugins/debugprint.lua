return {
  'andrewferrier/debugprint.nvim',
  opts = {},
  version = '*', -- Remove if you DON'T want to use the stable version
  config = function(_, opts)
    require('debugprint').setup(opts)
  end,
}
