vim.pack.add {
  'https://github.com/selimacerbas/markdown-preview.nvim',
  'https://github.com/selimacerbas/live-server.nvim',
}

require('markdown_preview').setup {
  -- all optional; sane defaults shown
  instance_mode = 'takeover', -- "takeover" (one tab) or "multi" (tab per instance)
  port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
  open_browser = true,
  debounce_ms = 300,
}
