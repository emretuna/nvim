local dark_palette = {
  base00 = '#1c1917', -- Background
  base01 = '#24221f', -- Lighter background (used for status bars, line numbers, etc.)
  base02 = '#2e2a27', -- Selection background
  base03 = '#3a3531', -- Comments, invisibles, line highlighting
  base04 = '#5c534c', -- Dark foreground (used for status bars)
  base05 = '#646464', -- Default foreground, caret, delimiters, operators
  base06 = '#b6ad9f', -- Light foreground (not often used)
  base07 = '#c8c8c8', -- Lightest foreground (used for bold text)
  base08 = '#a37b6f', -- Variables, XML tags, markup link text, bullet points
  base09 = '#dee5e5', -- Integers, booleans, constants, XML attributes
  base0A = '#B4BDC3', -- Classes, attributes, function parameters, search text background
  base0B = '#505050', -- Strings, inline code, escape characters
  base0C = '#6a6a6a', -- Support, regex, escape characters, special variables
  base0D = '#b0b0b0', -- Functions, methods, attributes
  base0E = '#707070', -- Keywords, storage, language constructs
  base0F = '#9c9c9c', -- Deprecated elements, embedded language tags
}

local light_palette = {
  base00 = '#F8FAFF', -- Background
  base01 = '#F0F2F9', -- Lighter background (used for status bars, line numbers, etc.)
  base02 = '#E8EAF2', -- Selection background
  base03 = '#B8BFCB', -- Comments, invisibles, line highlighting
  base04 = '#A3AAC0', -- Dark foreground (used for status bars)
  base05 = '#5C6370', -- Default foreground, caret, delimiters, operators
  base06 = '#4A5061', -- Light foreground (not often used)
  base07 = '#282C34', -- Lightest foreground (used for bold text)
  base08 = '#ba8d7f', -- Variables, XML tags, markup link text, bullet points
  base09 = '#4e5a5a', -- Integers, booleans, constants, XML attributes
  base0A = '#8899aa', -- Classes, attributes, function parameters, search text background
  base0B = '#707070', -- Strings, inline code, escape characters
  base0C = '#8a8a8a', -- Support, regex, escape characters, special variables
  base0D = '#595959', -- Functions, methods, attributes
  base0E = '#707070', -- Keywords, storage, language constructs
  base0F = '#c0c0c0', -- Deprecated elements, embedded language tags
}

-- Function to apply the colorscheme based on `vim.o.background`
local function apply_palette()
  local palette = vim.o.background == 'dark' and dark_palette or light_palette
  require('mini.base16').setup {
    palette = palette,
    use_cterm = true,
  }
  vim.g.colors_name = 'base16' -- Set colorscheme name
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
