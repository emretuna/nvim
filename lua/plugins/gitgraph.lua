return {
  'isakbm/gitgraph.nvim',
  dependencies = { 'sindrets/diffview.nvim' },
  ---@type I.GGConfig
  ---@diagnostic disable
  event = 'VeryLazy',
  opts = {
    format = {
      timestamp = '%H:%M:%S %d-%m-%Y',
      fields = { 'hash', 'timestamp', 'author', 'branch_name', 'tag' },
    },
    symbols = {
      merge_commit = 'M',
      commit = '*',
    },
    hooks = {
      -- Check diff of a commit
      on_select_commit = function(commit)
        vim.notify('DiffviewOpen ' .. commit.hash .. '^!')
        vim.cmd(':DiffviewOpen ' .. commit.hash .. '^!')
      end,
      -- Check diff from commit a -> commit b
      on_select_range_commit = function(from, to)
        vim.notify('DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
        vim.cmd(':DiffviewOpen ' .. from.hash .. '~1..' .. to.hash)
      end,
    },
  },
  config = function(_, opts)
    require('gitgraph').setup(opts)
    vim.keymap.set('n', '<leader>gg', function()
      require('gitgraph').draw({}, { all = true, max_count = 5000 })
    end, { desc = 'Git Graph' })
  end,
}
