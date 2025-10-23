local dark_palette = {
  base00 = '#1c1917', -- Background
  base01 = '#2a2520', -- Lighter background (used for status bars, line numbers, etc.)
  base02 = '#3a3530', -- Selection background
  base03 = '#6b6b6b', -- Comments, invisibles, line highlighting
  base04 = '#7b7b7b', -- Dark foreground (used for status bars)
  base05 = '#9b9b9b', -- Default foreground, caret, delimiters, operators
  base06 = '#ababab', -- Light foreground (not often used)
  base07 = '#d4d4d4', -- Lightest foreground (used for bold text)
  base08 = '#b38a7d', -- Variables, XML tags, markup link text, bullet points
  base09 = '#dee5e5', -- Integers, booleans, constants, XML attributes
  base0A = '#8c9ea5', -- Classes, attributes, function parameters, search text background
  base0B = '#8a909a', -- Strings, inline code, escape characters
  base0C = '#8a8a8a', -- Support, regex, escape characters, special variables
  base0D = '#a8a8a8', -- Functions, methods, attributes
  base0E = '#AC5963', -- Keywords, storage, language constructs
  base0F = '#505050', -- Deprecated elements, embedded language tags
}

local light_palette = {
  base00 = '#f8f8f8', -- Background (keep your original)
  base01 = '#e8e8e8', -- Lighter background (keep your original)
  base02 = '#d0d0d0', -- Selection background (more contrast)
  base03 = '#a0a0a0', -- Comments, invisibles, line highlighting (darker for visibility)
  base04 = '#787878', -- Dark foreground (used for status bars)
  base05 = '#4a4c58', -- Default foreground, caret, delimiters, operators (better contrast)
  base06 = '#383a48', -- Light foreground (not often used)
  base07 = '#282c34', -- Lightest foreground (used for bold text)
  base08 = '#c08070', -- Variables (warm tone, more saturated for light theme)
  base09 = '#5a6060', -- Integers, booleans, constants (darker than original)
  base0A = '#8c9ea5', -- Classes, attributes, function parameters (keep your color)
  base0B = '#505050', -- Strings, inline code (darker for readability)
  base0C = '#707070', -- Support, regex, escape characters (keep your original)
  base0D = '#787878', -- Functions, methods, attributes (darker than your dark theme)
  base0E = '#b85a63', -- Keywords, storage, language constructs (more saturated version)
  base0F = '#484848', -- Deprecated elements, embedded language tags (slightly lighter)
}

-- Function to apply the colorscheme based on `vim.o.background`
local function apply_palette()
  local palette = vim.o.background == 'dark' and dark_palette or light_palette
  require('mini.base16').setup {
    palette = palette,
    use_cterm = true,
  }
  vim.g.colors_name = 'base16' -- Set colorscheme name
  -- Sample highlight overriding
  -- vim.api.nvim_set_hl(0, 'Pmenu', { fg = palette.base05, bg = palette.base00 })
end
-- Apply the palette during initialization
apply_palette()

-- Set up an autocmd to change the palette dynamically
vim.api.nvim_create_autocmd('OptionSet', {
  pattern = 'background',
  callback = function()
    apply_palette()
  end,
})
