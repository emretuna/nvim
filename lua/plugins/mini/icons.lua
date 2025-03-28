require('mini.icons').setup {
  extension = {
    ['http'] = { glyph = '󰖟', hl = 'MiniIconsGreen' },
    ['rest'] = { glyph = '󱂛', hl = 'MiniIconsBlue' },
    ['.eslintrc.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
    ['.node-version'] = { glyph = '', hl = 'MiniIconsGreen' },
    ['.prettierrc'] = { glyph = '', hl = 'MiniIconsPurple' },
    ['.yarnrc.yml'] = { glyph = '', hl = 'MiniIconsBlue' },
    ['eslint.config.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
    ['package.json'] = { glyph = '', hl = 'MiniIconsGreen' },
    ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
    ['tsconfig.build.json'] = { glyph = '', hl = 'MiniIconsAzure' },
    ['yarn.lock'] = { glyph = '', hl = 'MiniIconsBlue' },
  },
  lsp = {
    supermaven = { glyph = '', hl = 'MiniIconsAzure' },
    codeium = { glyph = '', hl = 'MiniIconsGreen' },
    snippet = { glyph = '', hl = 'MiniIconsYellow' },
  },
}
MiniIcons.mock_nvim_web_devicons()
