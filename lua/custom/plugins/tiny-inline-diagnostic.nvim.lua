vim.pack.add { 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' }

require('tiny-inline-diagnostic').setup {
  preset = 'powerline',
  options = {
    add_messages = {
      display_count = true,
    },
    multilines = {
      enabled = true,
    },
  },
}

vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics
