vim.pack.add { 'https://github.com/petertriho/nvim-scrollbar' }

require('scrollbar').setup {
  handle = {
    -- A blank cell painted with the highlight's background, so the handle is
    -- only as visible as that background is.  `CursorColumn` (the default) is a
    -- faint tint by design; `Visual` is defined with real contrast in every
    -- colorscheme, which keeps this readable across all the themes in
    -- `lua/custom/themes/`.
    highlight = 'Visual',
    blend = 0, -- 0 = fully opaque, 100 = invisible
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
