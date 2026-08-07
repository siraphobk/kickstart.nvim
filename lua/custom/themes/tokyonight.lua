return {
  src = 'https://github.com/folke/tokyonight.nvim',
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('tokyonight').setup {
      styles = {
        comments = { italic = true },
        functions = { bold = true },
      },
      dim_inactive = true,
    }
  end,
}
