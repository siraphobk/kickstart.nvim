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

-- [[ nvim-scrollbar integration ]]
--
-- `scrollbar.handlers.search` bails with a warning if hlslens is not yet on the
-- runtimepath, and it patches `hlslens.config.build_position_cb`, so it has to
-- run *after* the `hlslens.setup` call above.  Files in this directory are
-- loaded in filesystem order, not alphabetical order, so nvim-scrollbar.lua may
-- well have already run -- waiting for VimEnter makes that race moot, since by
-- then both plugins are installed and both `setup` calls are done.
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Feed hlslens search matches to the nvim-scrollbar gutter',
  once = true,
  callback = function()
    local ok, search = pcall(require, 'scrollbar.handlers.search')
    if not ok then return end
    search.setup()
  end,
})
