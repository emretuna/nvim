return {
  'ahmedkhalf/project.nvim',
  cmd = 'ProjectRoot',
  event = 'VeryLazy',
  opts = {
    -- How to find root directory
    detection_methods = { 'pattern', 'lsp' },
    show_hidden = true, -- show hidden files in telescope
    --ignore_lsp = { "lua_ls" },
  },
  config = function(_, opts)
    require('project_nvim').setup(opts)
    local ok, fzf = pcall(require, 'fzf-lua')
    if ok then
      vim.keymap.set('n', '<leader>fp', function()
        fzf.fzf_exec(function(add_to_results)
          local contents = require('project_nvim').get_recent_projects()
          for _, project in pairs(contents) do
            add_to_results(project)
          end
          -- close the fzf named pipe, this signals EOF and terminates the fzf "loading" indicator.
          add_to_results()
        end, {
          prompt = 'Projects> ',
          actions = {
            ['default'] = function(choice)
              vim.cmd.edit(choice[1])
            end,
            ['ctrl-d'] = {
              function(choice)
                local history = require 'project_nvim.utils.history'
                local delete = vim.fn.confirm("Delete '" .. choice[1] .. "' projects? ", '&Yes\n&No', 2)
                if delete == 1 then
                  history.delete_project { value = choice[1] }
                end
              end,
              fzf.actions.resume,
            },
          },
        })
      end, { silent = true, desc = 'Projects' })
    end
  end,
}
