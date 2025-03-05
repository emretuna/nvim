-- mini plugins with configs
require 'plugins.mini.ai'
require 'plugins.mini.align'
require 'plugins.mini.animate'
require 'plugins.mini.bufremove'
require 'plugins.mini.files'
require 'plugins.mini.git'
require 'plugins.mini.hipatterns'
require 'plugins.mini.icons'
require 'plugins.mini.indentscope'
require 'plugins.mini.notify'
require 'plugins.mini.pairs'
require 'plugins.mini.pick'
require 'plugins.mini.visits'

require('mini.jump').setup()
require('mini.jump2d').setup()
require('mini.bracketed').setup()
require('mini.splitjoin').setup { mappings = { toggle = 'gS' } }
require('mini.extra').setup()
require('mini.surround').setup()
require('mini.move').setup()
require('mini.diff').setup { view = { style = 'sign', signs = { add = '+', change = '~', delete = '-' } } }
