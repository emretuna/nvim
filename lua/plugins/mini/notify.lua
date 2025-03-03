require('mini.notify').setup {
  window = {
    config = {
      border = vim.g.border_style,
    },
  },
}
vim.notify = require('mini.notify').make_notify()

return {}
