require('mini.hipatterns').setup {
  highlighters = {
    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    todo = require('mini.extra').gen_highlighter.words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
    hack = require('mini.extra').gen_highlighter.words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
    note = require('mini.extra').gen_highlighter.words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
    fixme = require('mini.extra').gen_highlighter.words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
  },
}
