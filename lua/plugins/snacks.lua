return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = '📁', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = '🌩️', key = 'o', desc = 'Recent Files', action = '<leader>fo' },
          { icon = '🐙', key = 'f', desc = 'Find File', action = '<leader>f.' },
          { icon = '🔎', key = 'g', desc = 'Find Grep', action = '<leader>f/' },
          { icon = '📋', key = 'b', desc = 'Bookmarks', action = '<leader>vl' },
          { icon = '⏳', key = 's', desc = 'Restore Session', section = 'session' },
          { icon = '👊', key = 'c', desc = 'Config', action = '<leader>fN' },
          { icon = '💤', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          { icon = '🚪', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        { section = 'header', padding = 4 },
        { section = 'keys', gap = 1, indent = 2, padding = 3 },
        { icon = '🔭', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
        { icon = '💼', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
        { section = 'startup' },
      },
    },
    statuscolumn = { enabled = false },
    animate = { enabled = false },
    profiler = { enabled = false },
    bigfile = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    words = { enabled = true },
    scroll = { enabled = false },
    terminal = {
      enabled = true,
      win = {
        style = 'terminal',
        border = vim.g.border_style,
        position = 'float',
        height = 0.8,
        width = 0.8,
      },
    },
    styles = {
      notification = {
        border = vim.g.border_style,
        wo = { wrap = true }, -- Wrap notifications
        history = {
          border = vim.g.border_style,
        },
      },
      scratch = {
        border = vim.g.border_style,
      },
    },
  },

  -- stylua: ignore start
  keys = {
		{ "<leader>uz",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>uZ",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>bs",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>b/",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>mn",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bx", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>bq", function() Snacks.bufdelete.all() end, desc = "Delete All Buffers" },
    { "<leader>bc", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
    { "<leader>mr", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>go", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
    { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
    { "<leader>g.", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<F7>",       function() Snacks.terminal(nil,{win = { position = 'bottom', height = 20 }}) end, desc = "Toggle Terminal" },
    { "<leader>ml", function() Snacks.terminal("lazydocker") end, desc = "LazyDocker" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
  },
  -- stylua: ignore end
  init = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
        Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
        Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>ur'
        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.line_number():map '<leader>ul'
        Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
        Snacks.toggle.treesitter():map '<leader>uT'
        Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
        Snacks.toggle.inlay_hints():map '<leader>uh'
      end,
    })
  end,
}
