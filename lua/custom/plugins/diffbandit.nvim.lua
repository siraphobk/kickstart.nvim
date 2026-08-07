-- Side-by-side diff viewer. Both documents keep their own line numbers and
-- shape; a connector gutter in the middle draws the relationship instead of
-- padding either side to force alignment.
--
-- The <leader>d maps below cover the Git review flows. Everything else stays a
-- command, because it needs arguments a keymap can't supply:
--   :DiffBandit <left> <right>     compare two files
--   :DiffBanditBuffers <n> <n>     compare two loaded buffers
--   :DiffBanditFolderDiff <l> <r>  recursive folder comparison
--   :DiffBanditMerge <file>        three-pane conflict resolver
--
-- Keys inside a diff view are buffer-local (]c, [c, ]f, [f, <Space>, q, ...),
-- so they don't collide with anything global.
vim.pack.add { 'https://github.com/CoreyKaylor/diffbandit.nvim' }

local diffbandit = require 'diffbandit'

-- Defaults are sensible and theme-aware: colors are derived from the active
-- colorscheme's diff highlight groups, and status icons auto-detect Nerd Fonts.
diffbandit.setup()

local set = vim.keymap.set

-- Every change in the repo, staged and unstaged. The daily entry point, so it
-- gets the double-tap.
set('n', '<leader>dd', function() diffbandit.git { mode = 'all' } end, { desc = '[D]iff: all git changes' })

-- Staged changes only -- what a commit would actually contain.
set('n', '<leader>ds', function() diffbandit.git { mode = 'staged' } end, { desc = '[D]iff: [S]taged changes only' })

-- Just the file you're in, against git.
set('n', '<leader>df', function() diffbandit.git_file(nil, { mode = 'all' }) end, { desc = '[D]iff: current [F]ile vs git' })

-- Stage files, write the message, `:w` in the message window commits.
set('n', '<leader>dc', function() diffbandit.commit_panel {} end, { desc = '[D]iff: [C]ommit panel' })

-- Browse recent commits; pick one to review the files it touched.
set('n', '<leader>dl', function() diffbandit.git_log {} end, { desc = '[D]iff: git [L]og' })

-- Review one commit's changes without leaving the diff view.
set('n', '<leader>dH', function() diffbandit.git_commit 'HEAD' end, { desc = '[D]iff: [H]EAD commit' })

-- Compare two branches; prompts for the refs. Defaults to a merge-base
-- comparison, which is what you want when reviewing a feature branch.
set('n', '<leader>db', function() diffbandit.git_compare_branches {} end, { desc = '[D]iff: compare [B]ranches' })

-- Discoverability hatch: lists the git actions when you don't recall the map.
set('n', '<leader>dm', function() diffbandit.git_menu {} end, { desc = '[D]iff: git [M]enu' })
