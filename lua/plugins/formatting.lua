local add = MiniDeps.add

add {
  source = 'stevearc/conform.nvim',
}

require('conform').setup {
  stop_after_first = true,
  notify_on_error = true,
  log_level = vim.log.levels.TRACE,

  -- format_on_save = function(bufnr)
  --   -- Disable "format_on_save lsp_fallback" for languages that don't
  --   -- have a well standardized coding style. You can add additional
  --   -- languages here or re-enable it for the disabled ones.
  --   local disable_filetypes = { c = true, cpp = true }
  --   if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
  --     return
  --   end
  --   -- ...additional logic...
  --   return {
  --     timeout_ms = 2500,
  --     lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
  --   }
  -- end,
  --
  format_after_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    -- ...additional logic...
    return {
      timeout_ms = 2500,
      lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      async = true,
      quiet = true,
    }
  end,
  formatters_by_ft = {
    typescript = { 'prettierd', 'prettier' },
    typescriptreact = { 'prettierd', 'prettier' },
    javascript = { 'prettierd', 'prettier' },
    javascriptreact = { 'prettierd', 'prettier' },
    svelte = { 'prettier' },
    css = { 'prettier' },
    html = { 'prettier' },
    json = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier', 'markdownlint' },
    graphql = { 'prettier' },
    lua = { 'stylua' },
    php = { 'pint', 'php_cs_fixer', 'phpcbf' },
    blade = { 'blade-formatter' },
    ['_'] = { 'trim_whitespace', 'trim_newlines' },

    -- python = { "isort", "black" },
    --
    -- You can use a sub-list to tell conform to run *until* a formatter
    -- is found.
    -- javascript = { { "prettierd", "prettier" } },
  },
}

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
    vim.notify('Autoformat on save disabled', vim.log.levels.WARN)
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
  vim.notify('Autoformat on save enabled', vim.log.levels.INFO)
end, {
  desc = 'Re-enable autoformat-on-save',
})

-- Add keymap to disable and enable format on save
vim.keymap.set('n', [[\f]], function()
  if vim.b.disable_autoformat or vim.g.disable_autoformat then
    vim.cmd 'FormatEnable'
  else
    vim.cmd 'FormatDisable'
  end
end, { desc = 'Toggle auto-format' })
