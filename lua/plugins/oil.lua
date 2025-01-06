return {
  'stevearc/oil.nvim',
  enabled = false,
  -- Optional dependencies
  opts = {
    default_file_explorer = false,
    columns = { 'icon' },
    keymaps = {
      ['<Esc><Esc>'] = 'actions.close',
      ['<C-h>'] = false,
      ['<C-s>'] = false,
      ['<C-t>'] = false,
      ['<C-l>'] = false,
      ['<C-r>'] = { 'actions.refresh', desc = 'Refresh the directory listing' },
      ['<M-s>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
      ['<M-h>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
      ['<M-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in a horizontal split' },
      ['gd'] = {
        desc = 'Toggle file detail view',
        callback = function()
          detail = not detail
          if detail then
            require('oil').set_columns { 'icon', 'permissions', 'size', 'mtime' }
          else
            require('oil').set_columns { 'icon' }
          end
        end,
      },
    },
    view_options = {
      show_hidden = true,
    },
    delete_to_trash = false,
    float = {
      -- Padding around the floating window
      padding = 2,
      max_width = 0,
      max_height = 0,
      border = vim.g.border_style,
      win_options = {
        winblend = 0,
        winhighlight = 'NormalFloat:Normal,FloatBorder:Normal',
      },
      preview_split = 'right',
    },
    -- Configuration for the floating SSH window
    ssh = {
      border = vim.g.border_style,
    },
    -- Configuration for the floating keymaps help window
    keymaps_help = {
      border = vim.g.border_style,
    },
    confirmation = {
      border = vim.g.border_style,
    },
    progress = {
      border = vim.g.border_style,
    },
  },
  config = function(_, opts)
    require('oil').setup(opts)

    -- Open parent directory in current window
    vim.keymap.set('n', '_', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

    -- Open parent directory in floating window
    vim.keymap.set('n', '-', require('oil').toggle_float, { desc = 'Open directory' })
  end,
}
