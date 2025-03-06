local dark_palette = {
  base00 = '#1C1917', -- Darkest background
  base01 = '#1e1e1e', -- Slightly lighter for contrast
  base02 = '#262626', -- Mid dark for UI elements
  base03 = '#303030', -- Comments and subtle text
  base04 = '#424242', -- Midtone for inactive elements
  base05 = '#646464', -- Default text, standard readability
  base06 = '#909090', -- Slightly lighter text for emphasis
  base07 = '#c8c8c8', -- Lightest text, headings
  base08 = '#a37b6f', -- Variables, markup link text
  base09 = '#dee5e5', -- Integers, booleans, constants
  base0A = '#708090', -- Classes, markup bold
  base0B = '#505050', -- Strings, markup code
  base0C = '#6a6a6a', -- Support, diff changed
  base0D = '#a8a8a8', -- Functions, methods
  base0E = '#5e5e5e', -- Keywords, storage
  base0F = '#404040', -- Deprecated, special tags
}

local light_palette = {
  base00 = '#f8f8f8', -- Lightest background
  base01 = '#eeeeee', -- Slightly darker for subtle contrast
  base02 = '#e0e0e0', -- Light gray for UI elements
  base03 = '#d2d2d2', -- Comments and subtle text
  base04 = '#bcbcbc', -- Midtone for inactive elements
  base05 = '#909090', -- Default text, standard readability
  base06 = '#606060', -- Slightly darker text for emphasis
  base07 = '#2b2b2b', -- Darkest text, headings
  base08 = '#ba8d7f', -- Variables, markup link text
  base09 = '#4e5a5a', -- Integers, booleans, constants
  base0A = '#8899aa', -- Classes, markup bold
  base0B = '#707070', -- Strings, markup code (aligned with neutral tones)
  base0C = '#8a8a8a', -- Support, diff changed
  base0D = '#595959', -- Functions, methods
  base0E = '#707070', -- Keywords, storage
  base0F = '#c0c0c0', -- Deprecated, special tags
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
