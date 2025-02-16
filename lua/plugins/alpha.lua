return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  -- enabled = false,
  cmd = 'Alpha',
  -- setup header and buttonts
  opts = function()
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = {
      '                                                     ',
      '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
      '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
      '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
      '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
      '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
      '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
      '                                                     ',
    }

    dashboard.section.header.opts.hl = 'DashboardHeader'
    -- vim.cmd 'highlight DashboardHeader guifg=#73daca'

    -- Buttons
    dashboard.section.buttons.val = {
      dashboard.button('n', '📋 New          ', '<cmd>enew<CR>                                         '),
      dashboard.button('o', '🌩️ Recent       ', ':lua vim.api.nvim_input("<leader>fo")<CR>             '),
      dashboard.button('f', '🐙 Find         ', ':lua vim.api.nvim_input("<leader>f.")<CR>             '),
      dashboard.button('g', '🔎 Grep         ', ':lua vim.api.nvim_input("<leader>f/")<CR>             '),
      dashboard.button('b', '📔 Bookmarks    ', ':lua vim.api.nvim_input("<leader>vl")<CR>             '),
      dashboard.button('s', '⏳ Sessions     ', '<cmd>lua MiniSessions.select()<CR>                    '),
      dashboard.button('l', '💤 Lazy         ', '<cmd>Lazy <cr>                                        '),
      dashboard.button('p', '💼 Projects     ', ':lua vim.api.nvim_input("<leader>fP")<CR>             '),
      dashboard.button(' ', '                '),
      dashboard.button('q', '🚪 Quit         ', '<cmd>exit<CR>                                         '),
    }

    ---- Vertical margins
    dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.10) } -- Above header
    dashboard.config.layout[3].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.10) } -- Above buttons
    return dashboard
  end,
  config = function(_, opts)
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaReady',
        callback = function()
          require('lazy').show()
        end,
      })
    end
    -- Footer
    require('alpha').setup(opts.config)
    -- Disable folding on alpha buffer
    vim.cmd [[
    autocmd FileType alpha setlocal nofoldenable
    ]]
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyVimStarted',
      desc = 'Add Alpha dashboard footer',
      once = true,
      callback = function()
        local stats = require('lazy').stats()
        stats.real_cputime = true
        local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
        opts.section.footer.val = {
          ' ',
          ' ',
          ' ',
          'Loaded ' .. stats.loaded .. ' plugins  in ' .. ms .. 'ms',
          '.............................',
        }
        opts.section.footer.opts.hl = 'DashboardFooter'
        vim.cmd 'highlight DashboardFooter guifg=#D29B68'
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
