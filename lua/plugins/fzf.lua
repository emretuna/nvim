return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  enabled = false,
  dependencies = { 'echasnovski/mini.icons' },
  opts = function()
    local img_previewer ---@type string[]?
    for _, v in ipairs {
      { cmd = 'ueberzug', args = {} },
      { cmd = 'chafa', args = { '{file}', '--format=symbols' } },
      { cmd = 'viu', args = { '-b' } },
    } do
      if vim.fn.executable(v.cmd) == 1 then
        img_previewer = vim.list_extend({ v.cmd }, v.args)
        break
      end
    end
    return {
      fzf_colors = {
        bg = { 'bg', 'Normal' },
        gutter = { 'bg', 'Normal' },
        info = { 'fg', 'Conditional' },
        scrollbar = { 'bg', 'Normal' },
        separator = { 'fg', 'Comment' },
      },
      fzf_opts = {
        ['--info'] = 'default',
        ['--layout'] = 'reverse-list',
        ['--no-scrollbar'] = true,
      },
      defaults = {
        -- formatter = 'path.filename_first',
        formatter = 'path.dirname_first',
      },
      previewers = {
        builtin = {
          extensions = {
            ['png'] = img_previewer,
            ['jpg'] = img_previewer,
            ['jpeg'] = img_previewer,
            ['gif'] = img_previewer,
            ['webp'] = img_previewer,
          },
          ueberzug_scaler = 'fit_contain',
        },
      },
      winopts = {
        default = 'bat',
        width = 0.80,
        height = 0.70,
        border = vim.g.border_style,
        preview = {
          scrollbar = false,
          vertical = 'up:40%',
          layout = 'vertical',
        },
      },
      keymap = {
        builtin = {
          true,
          ['<C-f>'] = 'preview-page-down',
          ['<C-b>'] = 'preview-page-up',
        },
        fzf = {
          true,
          ['ctrl-f'] = 'preview-page-down',
          ['ctrl-b'] = 'preview-page-up',
          ['ctrl-u'] = 'half-page-up',
          ['ctrl-d'] = 'half-page-down',
          ['ctrl-x'] = 'jump',
          ['ctrl-q'] = 'select-all+accept',
        },
      },
    }
  end,
  config = function(_, opts)
    -- calling `setup` is optional for customization
    require('fzf-lua').setup(opts)
    -- search
    vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Files' })
    vim.keymap.set('n', '<leader>fh', '<cmd>FzfLua help_tags<cr>', { desc = 'Find Help' })
    vim.keymap.set('n', '<leader>fc', '<cmd>FzfLua command_history<cr>', { desc = 'Find Command History' })
    vim.keymap.set('n', '<leader>fr', '<cmd>FzfLua resume<cr>', { desc = 'Find Resume' })
    vim.keymap.set('n', '<leader>fm', '<cmd>FzfLua marks<cr>', { desc = 'Find Marks' })
    vim.keymap.set('n', '<leader>fo', '<cmd>FzfLua oldfiles<cr>', { desc = 'Find Oldfiles' })
    vim.keymap.set('n', '<leader>fw', '<cmd>FzfLua grep_cword<cr>', { desc = 'Find current Word' })
    vim.keymap.set('v', '<leader>fw', '<cmd>FzfLua grep_visual<cr>', { desc = 'Find current Word' })
    vim.keymap.set('n', '<leader>fb', '<cmd>FzfLua grep_curbuf<cr>', { desc = 'Grep Buffer' })
    vim.keymap.set('n', '<leader>fk', '<cmd>FzfLua keymaps<cr>', { desc = 'Find Keymaps' })
    vim.keymap.set('n', '<leader>fs', '<cmd>FzfLua builtin<cr>', { desc = 'Find Select Builtin' })
    vim.keymap.set('n', '<leader>f/', '<cmd>FzfLua live_grep<cr>', { desc = 'Find Grep' })
    vim.keymap.set('n', '<leader>f.', '<cmd>FzfLua oldfiles cwd=~<cr>', { desc = 'Find Recent Files ("." for repeat)' })
    -- lsp
    vim.keymap.set('n', '<leader>la', '<cmd>FzfLua lsp_code_actions<cr>', { desc = 'LSP: Actions' })
    vim.keymap.set('n', '<leader>lr', '<cmd>FzfLua lsp_references<cr>', { desc = 'LSP: References' })
    vim.keymap.set('n', '<leader>ld', '<cmd>FzfLua lsp_definitions<cr>', { desc = 'LSP: Definitions' })
    vim.keymap.set('n', '<leader>lD', '<cmd>FzfLua lsp_declarations<cr>', { desc = 'LSP: Declarations' })
    vim.keymap.set('n', '<leader>ly', '<cmd>FzfLua lsp_typedefs<cr>', { desc = 'LSP: Type Definitions' })
    vim.keymap.set('n', '<leader>li', '<cmd>FzfLua lsp_implementations<cr>', { desc = 'LSP: Implementations' })
    vim.keymap.set('n', '<leader>ls', '<cmd>FzfLua lsp_document_symbols<cr>', { desc = 'LSP: Symbols' })
    vim.keymap.set('n', '<leader>lS', '<cmd>FzfLua lsp_workspace_symbols<cr>', { desc = 'LSP: Workspace Symbols' })
    vim.keymap.set('n', '<leader>lx', '<cmd>FzfLua lsp_diagnostics_document<cr>', { desc = 'LSP: Diagnostics Document' })
    vim.keymap.set('n', '<leader>lX', '<cmd>FzfLua lsp_diagnostics_workspace<cr>', { desc = 'LSP: Diagnostics Workspace' })
    vim.keymap.set('n', '<leader>l/', '<cmd>FzfLua lsp_live_workspace_symbols<cr>', { desc = 'LSP: Live Workspace Symbols' })
    vim.keymap.set('n', '<leader>l.', '<cmd>FzfLua lsp_finder<cr>', { desc = 'LSP: All LSP Locations' })

    -- git
    vim.keymap.set('n', '<leader>fg', '<cmd>FzfLua git_files<cr>', { desc = 'Find Git Files' })
    vim.keymap.set('n', '<leader>gc', '<cmd>FzfLua git_commits<cr>', { desc = 'Git Commits' })
    vim.keymap.set('n', '<leader>gS', '<cmd>FzfLua git_status<cr>', { desc = 'Git Status' })

    -- buffers
    vim.keymap.set('n', '<leader>b.', '<cmd>FzfLua buffers<cr>', { desc = 'Buffers' })

    -- tabs
    vim.keymap.set('n', '<leader>t.', '<cmd>FzfLua tabs<cr>', { desc = 'Tabs' })

    -- neoclip.nvim
    vim.keymap.set('n', '<leader>fy', '<cmd>:lua require("neoclip.fzf")()<cr>', { desc = 'Find Yank History' })

    -- Neovim config
    vim.keymap.set('n', '<leader>fC', function()
      -- specify vimconfig directory
      local choice = '~/.config/nvim'
      require('fzf-lua').files {
        prompt = 'NvimConfig » ',
        cwd = choice,
      }
      vim.cmd('chdir ' .. choice)
    end, { desc = 'Find Nvim Config' })
    -- Dotfiles config
    vim.keymap.set('n', '<leader>fD', function()
      -- specify vimconfig directory
      local choice = '~/.dotfiles'
      require('fzf-lua').files {
        prompt = 'DotFiles » ',
        cwd = choice,
      }
      vim.cmd('chdir ' .. choice)
    end, { desc = 'Find Dotfiles' })
  end,
}
