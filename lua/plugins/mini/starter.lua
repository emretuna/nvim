local function header()
  return [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ 
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ 
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ 
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ 
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ 
]]
end
require('mini.starter').setup {

  evaluate_single = true,
  query_updaters = 'abcdefghijklmnopqrstuvwxyz0123456789',
  header = header,
  items = {
    require('mini.starter').sections.builtin_actions(),
    require('mini.starter').sections.pick(),
    require('mini.starter').sections.recent_files(10, false),
    -- require('mini.starter').sections.recent_files(10, true),
    require('mini.starter').sections.sessions(5, true),
    {

      { name = 'Lazy', action = 'Lazy', section = 'Builtin actions' },
      { name = 'Mason', action = 'Mason', section = 'Builtin actions' },
      { name = 'Notes', action = 'ObsidianQuickSwitch', section = 'Builtin actions' },
    },
  },
  content_hooks = {
    require('mini.starter').gen_hook.adding_bullet(),
    require('mini.starter').gen_hook.aligning('center', 'center'),
    require('mini.starter').gen_hook.indexing('all', { 'Builtin actions' }),
    require('mini.starter').gen_hook.padding(3, 2),
  },
}
-- Record the time at the start of init.lua or your configuration file
local start_time = vim.loop.hrtime()

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- Calculate the startup time
    local ms = (vim.loop.hrtime() - start_time) / 1e6

    -- Set footer with startup time info
    require('mini.starter').config.footer = function()
      return string.format('⚡ Startup time: %.2f ms', ms)
    end

    vim.cmd [[do VimResized]]
  end,
})

return {}
