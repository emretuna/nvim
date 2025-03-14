require('mini.ai').setup {
  mappings = {
    around = 'a',
    inside = 'i',

    around_next = 'an',
    inside_next = 'in',
    around_last = 'al',
    inside_last = 'il',

    goto_left = 'g[',
    goto_right = 'g]',
  },
  n_lines = 500,
  custom_textobjects = {
    B = require('mini.extra').gen_ai_spec.buffer(),
    D = require('mini.extra').gen_ai_spec.diagnostic(),
    I = require('mini.extra').gen_ai_spec.indent(),
    L = require('mini.extra').gen_ai_spec.line(),
    N = require('mini.extra').gen_ai_spec.number(),
    o = require('mini.ai').gen_spec.treesitter({
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    }, {}),
    u = require('mini.ai').gen_spec.function_call(), -- u for "Usage"
    U = require('mini.ai').gen_spec.function_call { name_pattern = '[%w_]' }, -- without dot in function name
    f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
    c = require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
    t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
    d = { '%f[%d]%d+' }, -- digits
    e = { -- Word with case
      {
        '%u[%l%d]+%f[^%l%d]',
        '%f[%S][%l%d]+%f[^%l%d]',
        '%f[%P][%l%d]+%f[^%l%d]',
        '^[%l%d]+%f[^%l%d]',
      },
      '^().*()$',
    },
    g = function() -- Whole buffer, similar to `gg` and 'G' motion
      local from = { line = 1, col = 1 }
      local to = {
        line = vim.fn.line '$',
        col = math.max(vim.fn.getline('$'):len(), 1),
      }
      return { from = from, to = to }
    end,
  },
}
