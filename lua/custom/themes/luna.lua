return {
  src = 'https://github.com/WTFox/luna.nvim',
  config = function()
    require('luna').setup {
      transparent = false,
      accent = 1.0, -- 0-1, blends syntax accents toward grey; 1 = full color
      plugins = {
        -- `auto` autodetects integrations through lazy.nvim, which this config
        -- does not use (we're on vim.pack), so enable every integration outright.
        all = true,
        auto = false,
      },
    }
  end,
}
