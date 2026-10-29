vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

require('diffview').setup {
  default_args = {
    -- Use the local files on disk instead instead of using the git commit history snapshot.
    -- This will also allow LSP to work e.g. syntax highlighting, etc.
    DiffViewOpen = { '--imply-local' },
  },
}

vim.api.nvim_create_user_command('DiffviewPRStyle', function(opts)
  -- Default target is origin/main if no argument is provided
  local target_branch = 'origin/main'

  -- If an argument exists, use it instead
  if opts.args ~= '' then target_branch = opts.args end

  -- Construct and execute the Diffview command
  local cmd = string.format('DiffviewOpen %s...HEAD --imply-local', target_branch)
  vim.cmd(cmd)
end, {
  nargs = '?', -- Allows 0 or 1 argument
  desc = 'Review current branch against origin/main or a custom branch (PR style). Accepts 1 argument which is the base branch name.',
})
