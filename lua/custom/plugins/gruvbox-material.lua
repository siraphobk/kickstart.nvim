return {
  'sainnhe/gruvbox-material',
  priority = 1000, -- load colorscheme before other plugins
  config = function()
    -- gruvbox-material is configured through globals, not a setup() call.
    vim.g.gruvbox_material_background = 'hard' -- 'soft' | 'medium' | 'hard'
    vim.g.gruvbox_material_foreground = 'material' -- 'material' | 'mix' | 'original'
    vim.g.gruvbox_material_enable_italic = true
    vim.g.gruvbox_material_enable_bold = true
    vim.g.gruvbox_material_dim_inactive_windows = true
    vim.g.gruvbox_material_better_performance = true

    -- Default colorscheme. Switch with `:Telescope colorscheme`.
    vim.cmd.colorscheme 'gruvbox-material'

    -- Force pure black background for the active window. Inactive windows keep
    -- gruvbox-material's dimmed bg via dim_inactive_windows (NormalNC).
    -- Re-applied on ColorScheme so a `:colorscheme` switch back here keeps black.
    local function black_active_bg()
      for _, group in ipairs { 'Normal' } do
        vim.api.nvim_set_hl(0, group, { bg = '#0c0c0c' })
      end
    end
    black_active_bg()
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'gruvbox-material',
      callback = black_active_bg,
    })
  end,
}
