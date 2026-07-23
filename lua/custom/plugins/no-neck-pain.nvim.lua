vim.pack.add { { src = 'https://github.com/shortcuts/no-neck-pain.nvim', version = vim.version.range '*' } }

require('no-neck-pain').setup {
  width = 120,
  mappings = {
    enabled = true,
  },
}
