local add = MiniDeps.add
add {
  source = 'dmtrKovalenko/fff.nvim',
  hooks = {
    post_install = function(params)
      vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
    end,
    post_checkout = function(params)
      vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
    end,
  },
  depends ={'folke/snacks.nvim'},
}

require('fff').setup {
  hl = {
    border = vim.g.border_style,
  },
}

vim.keymap.set('n', '<leader>fF', function()
  require('fff').find_files()
end, { desc = 'Find File' })
