vim.pack.add {
  'https://github.com/selimacerbas/mdkite.nvim',
  'https://github.com/selimacerbas/kitehost.nvim',
}

require('mdkite').setup {
  instance_mode = 'takeover', -- "takeover" (one tab) or "multi" (tab per instance)
  port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
  open_browser = true,
  debounce_ms = 300,
}
