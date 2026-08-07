vim.pack.add { 'https://github.com/petertriho/nvim-scrollbar' }

require('scrollbar').setup {
  handle = {
    -- The handle is a blank cell, so it reads purely as a background colour.
    -- A fixed grey rather than one borrowed from the theme: every colorscheme in
    -- `lua/custom/themes/` is dark, so one mid-grey sits right on all of them,
    -- and the obvious groups to borrow from are not actually grey everywhere --
    -- tokyonight's `Visual` is navy (#2d3f76).  Lower this hex for a quieter
    -- handle, raise it for a brighter one.
    color = '#404040',
    blend = 0, -- 0 = solid, 100 = invisible
  },
  marks = {
    Cursor = { text = '▶' },
    Search = { text = { '▪', '▮' } },
    Error = { text = { '▪', '▮' } },
    Warn = { text = { '▪', '▮' } },
    Info = { text = { '▪', '▮' } },
    Hint = { text = { '▪', '▮' } },
    Misc = { text = { '▪', '▮' } },
    GitAdd = { text = '┃' },
    GitChange = { text = '┃' },
    GitDelete = { text = '▁' },
  },
  handlers = {
    cursor = true,
    diagnostic = true,
    gitsigns = true, -- hunk marks; needs the handler setup call below
    handle = true,
    -- Left off on purpose: turning it on here makes scrollbar's own setup call
    -- the search handler immediately, which warns if hlslens has not loaded
    -- yet.  nvim-hlslens.lua enables it on VimEnter instead, once both plugins
    -- are ready.
    search = false,
  },
  excluded_buftypes = { 'terminal', 'nofile' },
  excluded_filetypes = {
    'blink-cmp-menu',
    'prompt',
    'TelescopePrompt',
    'neo-tree',
    'aerial',
    'grug-far',
    'no-neck-pain',
    'toggleterm',
  },
}

-- gitsigns is configured in init.lua, which runs before this file, so the
-- handler can attach right away.
require('scrollbar.handlers.gitsigns').setup()
