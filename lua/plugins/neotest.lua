local add = MiniDeps.add

add {
  source = 'nvim-neotest/neotest',
  depends = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    -- 'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- Custom test suites
    'olimorris/neotest-phpunit',
    'marilari88/neotest-vitest',
    'nvim-neotest/neotest-jest',
    'thenbe/neotest-playwright',
  },
}
require('neotest').setup {
  adapters = {
    require 'neotest-phpunit',
    require 'neotest-vitest',
    require 'neotest-jest' {
      jestCommand = 'npm test --',
      jestConfigFile = 'custom.jest.config.ts',
      env = { CI = true },
      cwd = function(path)
        return vim.fn.getcwd()
      end,
    },
    require 'neotest-playwright',
  },
}

-- get neotest namespace (api call creates or returns namespace)
local neotest_ns = vim.api.nvim_create_namespace 'neotest'
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
      return message
    end,
  },
}, neotest_ns)
