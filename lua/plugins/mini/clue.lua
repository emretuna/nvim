require('mini.clue').setup {
  window = {
    delay = 300,
    scroll_down = '<C-d>',
    scroll_up = '<C-u>',
    config = {
      width = '30',
      border = vim.g.border_style,
    },
  },
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },

    -- Bracketed Keybinds
    { mode = 'n', keys = ']' },
    { mode = 'n', keys = '[' },

    -- Surround Keybinds
    { mode = 'n', keys = [[\]] },

    -- Toggle Keybinds
    { mode = 'n', keys = 's' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    require('mini.clue').gen_clues.builtin_completion(),
    require('mini.clue').gen_clues.g(),
    require('mini.clue').gen_clues.marks(),
    require('mini.clue').gen_clues.registers(),
    require('mini.clue').gen_clues.windows(),
    require('mini.clue').gen_clues.z(),
    -- Custom clues
    { mode = 'n', keys = '<Leader>a', desc = 'Avante' },
    { mode = 'x', keys = '<Leader>a', desc = 'Avante' },
    { mode = 'n', keys = '<Leader>b', desc = 'Buffer' },
    { mode = 'n', keys = '<Leader>f', desc = 'Find' },
    { mode = 'n', keys = '<Leader>g', desc = 'Git' },
    { mode = 'n', keys = '<Leader>h', desc = 'Http' },
    { mode = 'n', keys = '<Leader>n', desc = 'Notes' },
    { mode = 'n', keys = '<Leader>o', desc = 'Overseer' },
    { mode = 'n', keys = '<Leader>q', desc = 'Quickfix' },
    { mode = 'n', keys = '<Leader>r', desc = 'Refactor' },
    { mode = 'n', keys = '<Leader>t', desc = 'Tabs' },
    { mode = 'n', keys = '<Leader>m', desc = 'Misc' },
    { mode = 'n', keys = '<Leader>u', desc = 'UI' },
    { mode = 'n', keys = '<Leader>v', desc = 'Visits' },
    { mode = 'n', keys = '<Leader>w', desc = 'Window' },
    { mode = 'n', keys = '<Leader>x', desc = 'Trouble' },
  },
}

return {}
