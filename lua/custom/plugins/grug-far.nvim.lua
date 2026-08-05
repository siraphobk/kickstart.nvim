-- Find & replace across the project, powered by ripgrep.
-- Replaces nvim-spectre (see nvim-spectre.lua, now disabled).
vim.pack.add { 'https://github.com/MagicDuck/grug-far.nvim' }

local grug = require 'grug-far'

-- No options are required; a named default instance keeps the buffer reusable
-- so `<leader>rr` toggles the same window instead of stacking new ones.
grug.setup {}

local set = vim.keymap.set

-- Toggle the main find/replace window. Reuses one named instance.
set('n', '<leader>rr', function() grug.toggle_instance { instanceName = 'far', staticTitle = 'Find and Replace' } end, { desc = 'Find/[R]eplace: toggle window' })

-- Prefill the search with the word under the cursor.
set('n', '<leader>rw', function() grug.open { prefills = { search = vim.fn.expand '<cword>' } } end, { desc = 'Find/[R]eplace: current [W]ord' })

-- Prefill the search with the visual selection.
set('x', '<leader>rw', function() grug.with_visual_selection {} end, { desc = 'Find/[R]eplace: selection' })

-- Limit search/replace to the current file only.
set('n', '<leader>rf', function() grug.open { prefills = { paths = vim.fn.expand '%' } } end, { desc = 'Find/[R]eplace: current [F]ile' })

-- Same, but seeded with the visual selection.
set('x', '<leader>rf', function() grug.with_visual_selection { prefills = { paths = vim.fn.expand '%' } } end, { desc = 'Find/[R]eplace: selection in current [F]ile' })

-- Limit search/replace to the selected lines (buffer range).
set('x', '<leader>rb', function()
  local range = grug.get_current_visual_selection_as_range_str()
  grug.open { prefills = { bufrange = range } }
end, { desc = 'Find/[R]eplace: within selected [B]uffer range' })

-- Restrict the search to files matching the current file's extension.
set('n', '<leader>re', function()
  local ext = vim.fn.expand '%:e'
  grug.open { prefills = { filesFilter = ext ~= '' and ('*.' .. ext) or nil } }
end, { desc = 'Find/[R]eplace: files with same [E]xtension' })
