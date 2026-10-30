-- Pinned to the v2 branch until v2 replaces v1 on `main` (2026-11-16); drop `version` after that.
vim.pack.add { { src = 'https://github.com/petertriho/nvim-scrollbar', version = 'refactor/v2' } }

require('scrollbar').setup {
  providers = {
    gitsigns = true, -- hunk marks; gitsigns is configured in init.lua
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
  -- Tables keyed by name add to the built-in excludes; a list would replace them.
  exclude = {
    buftypes = { nofile = true },
    filetypes = {
      ['neo-tree'] = true,
      Outline = true,
      ['grug-far'] = true,
      ['no-neck-pain'] = true,
      toggleterm = true,
    },
  },
  scrollbar = {
    thumb = {
      -- The thumb is a blank cell, so it reads purely as a background colour.
      -- A fixed grey rather than one borrowed from the theme: every colorscheme in
      -- `lua/custom/themes/` is dark, so one mid-grey sits right on all of them,
      -- and the obvious groups to borrow from are not actually grey everywhere --
      -- tokyonight's `Visual` is navy (#2d3f76).  Lower this hex for a quieter
      -- thumb, raise it for a brighter one.
      highlight = { bg = '#404040' },
      blend = 0, -- 0 = solid, 100 = invisible
    },
  },
}
