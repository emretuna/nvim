return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  enabled = false,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
  },
  keys = {
    { '<leader>fn', '<cmd>Noice<cr>', desc = 'Noice Messages' },
  },
  opts = function()
    local enable_conceal = true -- Hide command text if true
    local enable_lsp = true
    return {
      presets = { bottom_search = true }, -- The kind of popup used for /
      routes = {
        {
          -- view = 'cmdline',
          view = 'notify',
          filter = { event = 'msg_showmode' },
        },
        {
          filter = {
            event = 'notify',
            find = 'No information available',
          },
          opts = {
            skip = true,
          },
        },
      },
      cmdline = {
        view = 'cmdline', -- The kind of popup used for :
        format = {
          cmdline = { conceal = enable_conceal },
          search_down = { conceal = enable_conceal },
          search_up = { conceal = enable_conceal },
          filter = { conceal = enable_conceal },
          lua = { conceal = enable_conceal },
          help = { conceal = enable_conceal },
          input = { conceal = enable_conceal },
        },
      },

      -- Disable every other noice feature
      messages = { enabled = enable_lsp },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
        hover = { enabled = true },
        signature = { enabled = true },
        progress = { enabled = enable_lsp },
        message = { enabled = enable_lsp },
        smart_move = { enabled = enable_lsp },
        documentation = {
          opts = {
            border = { style = 'rounded' },
            position = { row = 2 },
          },
        },
      },
    }
  end,
  config = function(_, opts)
    require('noice').setup(opts)
    vim.keymap.set({ 'n', 'i', 's' }, '<c-f>', function()
      if not require('noice.lsp').scroll(4) then
        return '<c-f>'
      end
    end, { silent = true, expr = true })

    vim.keymap.set({ 'n', 'i', 's' }, '<c-b>', function()
      if not require('noice.lsp').scroll(-4) then
        return '<c-b>'
      end
    end, { silent = true, expr = true })
  end,
}
