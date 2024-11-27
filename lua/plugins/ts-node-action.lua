return {
  {
    'ckolkey/ts-node-action',
    dependencies = { 'nvim-treesitter' },
    opts = {},
    keys = {
      {
        '<leader>ma',
        function()
          require('ts-node-action').node_action()
        end,
        desc = 'TSNodeAction',
      },
    },
  },
}
