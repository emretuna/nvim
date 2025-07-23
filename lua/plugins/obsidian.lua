local add = MiniDeps.add
add {
  source = 'obsidian-nvim/obsidian.nvim',
  depends = { 'nvim-lua/plenary.nvim' },
}

require('obsidian').setup {
  legacy_commands = false,
  workspaces = {
    {
      name = 'Dev',
      path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Dev/',
    },
    {
      name = 'Personal',
      path = '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Personal/',
    },
  },
  ui = { enable = false },
  completion = { blink = true, nvim_cmp = false },
  picker = {
    name = 'mini.pick',
  },
  -- Optional, customize how names/IDs for new notes are created.
  note_id_func = function(title)
    -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
    -- In this case a note with the title 'My new note' will be given an ID that looks
    -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
    local suffix = ''
    if title ~= nil then
      -- If title is given, transform it into valid file name.
      suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
    else
      -- If title is nil, just add 4 random uppercase letters to the suffix.
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. '-' .. suffix
  end,
}
vim.opt.conceallevel = 1

-- Obsidian Daily
vim.keymap.set('n', '<leader>nd', ':Obsidian today<cr>', { desc = 'Daily' })
-- Obsidian Tomorrow
vim.keymap.set('n', '<leader>nt', ':Obsidian today 1<cr>', { desc = 'Tomorrow' })
-- Obsidian Yesterday
vim.keymap.set('n', '<leader>ny', ':Obsidian today -1<cr>', { desc = 'Yesterday' })
-- Obsidian Backlinks
vim.keymap.set('n', '<leader>nb', ':Obsidian backlinks<cr>', { desc = 'Backlinks' })
-- Obsidian Link Selection
vim.keymap.set('n', '<leader>nl', ':Obsidian link<cr>', { desc = 'Link Selection' })
-- Obsidian Follow Link
vim.keymap.set('n', '<leader>nf', ':Obsidian follow_link<cr>', { desc = 'Follow Link' })
-- Obsidian New
vim.keymap.set('n', '<leader>nn', ':Obsidian new<cr>', { desc = 'New' })
-- Obsidian Search
vim.keymap.set('n', '<leader>ns', ':Obsidian search<cr>', { desc = 'Search' })
-- Obsidian Open Quickswitch
vim.keymap.set('n', '<leader>n.', ':Obsidian quick_switch<cr>', { desc = 'Quickswitch' })
-- Obsidian Open In App
vim.keymap.set('n', '<leader>no', ':Obsidian open<cr>', { desc = 'Open In App' })
