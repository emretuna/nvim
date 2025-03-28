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
    -- IDE Features
    supermaven = { glyph = '', hl = 'MiniIconsAzure' },
    codeium = { glyph = '', hl = 'MiniIconsGreen' },
    -- Data Types
    array = { glyph = '󰅪', hl = 'MiniIconsBlue' },
    boolean = { glyph = '⊨', hl = 'MiniIconsAzure' },
    key = { glyph = '󰌆', hl = 'MiniIconsYellow' },
    namespace = { glyph = '󰅪', hl = 'MiniIconsBlue' },
    null = { glyph = 'NULL', hl = 'MiniIconsGray' },
    number = { glyph = '#', hl = 'MiniIconsPurple' },
    object = { glyph = '󰀚', hl = 'MiniIconsOrange' },
    package = { glyph = '󰏗', hl = 'MiniIconsBlue' },
    string = { glyph = '󰀬', hl = 'MiniIconsGreen' },
    typeParameter = { glyph = '󰊄', hl = 'MiniIconsAzure' },
    text = { glyph = '󰉿', hl = 'MiniIconsGreen' },
    -- Functions & Methods
    method = { glyph = '󰆧', hl = 'MiniIconsYellow' },
    ['function'] = { glyph = '󰊕', hl = 'MiniIconsYellow' },
    constructor = { glyph = '', hl = 'MiniIconsRed' },
    -- Variables & Properties
    field = { glyph = '󰜢', hl = 'MiniIconsBlue' },
    variable = { glyph = '󰀫', hl = 'MiniIconsBlue' },
    property = { glyph = '󰜢', hl = 'MiniIconsBlue' },
    -- Class-related
    class = { glyph = '󰠱', hl = 'MiniIconsOrange' },
    interface = { glyph = '', hl = 'MiniIconsAzure' },
    module = { glyph = '', hl = 'MiniIconsBlue' },
    -- Other Types
    unit = { glyph = '󰑭', hl = 'MiniIconsGreen' },
    value = { glyph = '󰎠', hl = 'MiniIconsPurple' },
    enum = { glyph = '', hl = 'MiniIconsPurple' },
    keyword = { glyph = '󰌋', hl = 'MiniIconsRed' },
    snippet = { glyph = '', hl = 'MiniIconsYellow' },
    color = { glyph = '󰏘', hl = 'MiniIconsRed' },
    file = { glyph = '󰈙', hl = 'MiniIconsBlue' },
    reference = { glyph = '󰈇', hl = 'MiniIconsOrange' },
    folder = { glyph = '󰉋', hl = 'MiniIconsBlue' },
    enumMember = { glyph = '', hl = 'MiniIconsPurple' },
    constant = { glyph = '󰏿', hl = 'MiniIconsPurple' },
    struct = { glyph = '󰙅', hl = 'MiniIconsOrange' },
    event = { glyph = '', hl = 'MiniIconsYellow' },
    operator = { glyph = '󰆕', hl = 'MiniIconsRed' },
  },
}
MiniIcons.mock_nvim_web_devicons()
