local dark_palette = {
  base00 = '#1c1917', -- Background
  base01 = '#24221f', -- Lighter background (used for status bars, line numbers, etc.)
  base02 = '#35332f', -- Selection background
  base03 = '#5c5c5c', -- Comments, invisibles, line highlighting
  base04 = '#424242', -- Dark foreground (used for status bars)
  base05 = '#7a7a7a', -- Default foreground, caret, delimiters, operators
  base06 = '#909090', -- Light foreground (not often used)
  base07 = '#c8c8c8', -- Lightest foreground (used for bold text)
  base08 = '#b38a7d', -- Variables, XML tags, markup link text, bullet points
  base09 = '#dee5e5', -- Integers, booleans, constants, XML attributes
  base0A = '#8c9ea5', -- Classes, attributes, function parameters, search text background
  base0B = '#5a5a5a', -- Strings, inline code, escape characters
  base0C = '#6c6c6c', -- Support, regex, escape characters, special variables
  base0D = '#bcbcbc', -- Functions, methods, attributes
  base0E = '#5e5e5e', -- Keywords, storage, language constructs
  base0F = '#404040', -- Deprecated elements, embedded language tags
}

local light_palette = {
  base00 = '#f8f8f8', -- Background
  base01 = '#f0f0f0', -- Lighter background (used for status bars, line numbers, etc.)
  base02 = '#e8e8e8', -- Selection background
  base03 = '#b0b0b0', -- Comments, invisibles, line highlighting
  base04 = '#a0a0a0', -- Dark foreground (used for status bars)
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
