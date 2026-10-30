vim.pack.add { 'https://github.com/kevinhwang91/nvim-hlslens' }

require('hlslens').setup {}

-- `n`/`N` and `*`/`#` need to call `hlslens.start()` after the motion so the
-- lens redraws for the new match; the plain builtins do not know about it.
local function jump(keys, desc)
  vim.keymap.set('n', keys, ([[<Cmd>execute('normal! ' . v:count1 . '%s')<CR><Cmd>lua require('hlslens').start()<CR>]]):format(keys), { silent = true, desc = desc })
end

jump('n', 'Next search match (with lens)')
jump('N', 'Previous search match (with lens)')

for _, keys in ipairs { '*', '#', 'g*', 'g#' } do
  vim.keymap.set('n', keys, keys .. [[<Cmd>lua require('hlslens').start()<CR>]], { silent = true, desc = 'Search word under cursor (with lens)' })
end
