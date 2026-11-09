vim.pack.add {
  'https://github.com/selimacerbas/mdkite.nvim',
  'https://github.com/selimacerbas/kitehost.nvim',
}

local mdkite = require 'mdkite'
mdkite.setup {
  instance_mode = 'takeover', -- "takeover" (one tab) or "multi" (tab per instance)
  port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
  open_browser = true,
  debounce_ms = 300,
  hooks = {
    -- In takeover mode a second Neovim joins the running preview and mdkite opens no tab for it.
    on_start = function(url)
      if mdkite._is_primary == false then vim.ui.open(url) end
    end,
  },
}
