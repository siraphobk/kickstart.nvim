vim.pack.add { 'https://github.com/MeanderingProgrammer/render-markdown.nvim' }

---@module 'render-markdown'
---@type render.md.UserConfig
local opts = {}

require('render-markdown').setup(opts)
