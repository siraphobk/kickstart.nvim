vim.pack.add { 'https://github.com/sphamba/smear-cursor.nvim' }

require('smear_cursor').setup {
  cursor_color = 'none',
  stiffness = 0.6, -- Lower = slower/longer trail (0.1 to 1)
  trailing_stiffness = 0.3, -- Smoothness of the tail end
  distance_stop_animating = 0.1,
}
