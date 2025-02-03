-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({ { import = 'plugins' } }, {
  -- Enable luarocks if installed.
  rocks = { enabled = vim.fn.executable 'luarocks' == 1 },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = { -- Use deflate to download faster from the plugin repos.
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'rplugin',
        'tarPlugin',
        'tutor',
        'zipPlugin',
        '2html_plugin',
        'osc52',
        'tohtml',
        'getscript',
        'getscriptPlugin',
        'logipat',
        -- 'netrw',
        -- 'netrwPlugin',
        -- 'netrwSettings',
        -- 'netrwFileHandlers',
        'tar',
        'rrhelper',
        'zip',
        'syntax',
        'synmenu',
        'optwin',
        'bugreport',
        'ftplugin',
      },
    },
  },
  install = {
    colorscheme = { 'mellifluous' },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = true,
  },
})
-- vim: ts=2 sts=2 sw=2 et
