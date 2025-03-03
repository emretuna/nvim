local add = MiniDeps.add

add {
  source = 'ThePrimeagen/refactoring.nvim',
  depends = { 'nvim-lua/plenary.nvim' },
}

require('refactoring').setup {
  prompt_func_param_type = {
    cpp = true,
    hpp = true,
    c = true,
    h = true,
  },
  prompt_func_return_type = {
    cpp = true,
    hpp = true,
    c = true,
    h = true,
  },
}
vim.keymap.set('x', '<leader>re', ':Refactor extract ', { desc = 'Extract to function' })
vim.keymap.set('x', '<leader>rf', ':Refactor extract_to_file ', { desc = 'Extract to File' })
vim.keymap.set('x', '<leader>rv', ':Refactor extract_var ', { desc = 'Extract to Variable' })
vim.keymap.set({ 'n', 'x' }, '<leader>ri', ':Refactor inline_var', { desc = 'Inline Variable' })
vim.keymap.set('n', '<leader>rI', ':Refactor inline_func', { desc = 'Inline Function' })
vim.keymap.set('n', '<leader>rb', ':Refactor extract_block', { desc = 'Extract to Block' })
vim.keymap.set('n', '<leader>rF', ':Refactor extract_block_to_file', { desc = 'Extract to Block to File' })

-- prompt for a refactor to apply when the remap is triggered
vim.keymap.set({ 'n', 'x' }, '<leader>r.', function()
  require('refactoring').select_refactor {}
end, { desc = 'Open Refactoring Menu' })
-- Note that not all refactor support both normal and visual mode
