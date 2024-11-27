return {
  'ThePrimeagen/refactoring.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  event = 'VeryLazy',
  opts = {
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
  },
  cmd = 'Refactor',
  keys = {
    vim.keymap.set('x', '<leader>re', ':Refactor extract '),
    vim.keymap.set('x', '<leader>rf', ':Refactor extract_to_file '),
    vim.keymap.set('x', '<leader>rv', ':Refactor extract_var '),
    vim.keymap.set({ 'n', 'x' }, '<leader>ri', ':Refactor inline_var'),
    vim.keymap.set('n', '<leader>rI', ':Refactor inline_func'),
    vim.keymap.set('n', '<leader>rb', ':Refactor extract_block'),
    vim.keymap.set('n', '<leader>rF', ':Refactor extract_block_to_file'),

    -- prompt for a refactor to apply when the remap is triggered
    vim.keymap.set({ 'n', 'x' }, '<leader>r.', function()
      require('refactoring').select_refactor {}
    end, { desc = 'Open Refactoring Menu' }),
    -- Note that not all refactor support both normal and visual mode
  },
}
