assert(type(vim.g.clipboard) == 'table' and vim.g.clipboard.name == 'OSC 52', 'Run this test with OSC 52, for example with ZELLIJ=0')
assert(vim.fn.has 'clipboard' == 1, 'The OSC 52 clipboard provider must be available')

local original_buffer = vim.api.nvim_get_current_buf()
local buffer = vim.api.nvim_create_buf(false, true)
vim.api.nvim_set_current_buf(buffer)

local function set_lines(lines)
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

local function assert_lines(expected)
  local actual = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
  assert(vim.deep_equal(actual, expected), 'Expected ' .. vim.inspect(expected) .. ', got ' .. vim.inspect(actual))
end

set_lines { 'alpha beta' }
vim.cmd.normal { args = { '"+yiw' }, bang = true }
vim.cmd.normal { args = { '$"+p' }, bang = true }
assert_lines { 'alpha betaalpha' }
assert(vim.fn.getregtype '+' == 'v', 'Characterwise yanks must retain their register type')

set_lines { 'alpha', 'beta', 'gamma' }
vim.cmd.normal { args = { 'ggVj"+y' }, bang = true }
vim.cmd.normal { args = { 'G"+p' }, bang = true }
assert_lines { 'alpha', 'beta', 'gamma', 'alpha', 'beta' }
assert(vim.fn.getregtype '+' == 'V', 'Linewise yanks must retain their register type')

set_lines { 'abcd', 'efgh' }
vim.cmd.normal { args = { 'gg\022jl"+y' }, bang = true }
assert(vim.fn.getregtype '+' == '\0222', 'Blockwise yanks must retain their width')
set_lines { '----', '----' }
vim.cmd.normal { args = { '"+p' }, bang = true }
assert_lines { '-ab---', '-ef---' }

vim.api.nvim_set_current_buf(original_buffer)
vim.api.nvim_buf_delete(buffer, { force = true })
print 'PASS: characterwise, linewise, and blockwise clipboard yank/paste'
