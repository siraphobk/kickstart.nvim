return {
  'loctvl842/monokai-pro.nvim',
  config = function()
    require('monokai-pro').setup {
      override = function(colors)
        return {
          -- Make the focused buffer darker
          Normal = { bg = colors.base.black },
          SignColumn = { bg = colors.base.black },
          LineNr = { bg = colors.base.black },

          -- Keep inactive buffers at the default theme background
          NormalNC = { bg = colors.editor.background },
        }
      end,
      transparent_background = false,
      terminal_colors = true,
      devicons = true, -- highlight the icons of `nvim-web-devicons`
      styles = {
        comment = { italic = true },
        keyword = { italic = true }, -- any other keyword
        type = { italic = true }, -- (preferred) int, long, char, etc
        storageclass = { italic = true }, -- static, register, volatile, etc
        structure = { italic = true }, -- struct, union, enum, etc
        parameter = { italic = true }, -- parameter pass in function
        annotation = { italic = true },
        tag_attribute = { italic = true }, -- attribute of tag in reactjs
      },
      filter = 'classic', -- classic | octagon | pro | machine | ristretto | spectrum
      -- Enable this will disable filter option
      day_night = {
        enable = false, -- turn off by default
        day_filter = 'pro', -- classic | octagon | pro | machine | ristretto | spectrum
        night_filter = 'spectrum', -- classic | octagon | pro | machine | ristretto | spectrum
      },
      inc_search = 'background', -- underline | background
      background_clear = {
        -- "float_win",
        'toggleterm',
        'telescope',
        -- "which-key",
        'renamer',
        'notify',
        -- "nvim-tree",
        -- "neo-tree",
        -- "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
      }, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree", "nvim-tree", "bufferline"
      plugins = {
        bufferline = {
          underline_selected = false,
          underline_visible = false,
        },
        indent_blankline = {
          context_highlight = 'default', -- default | pro
          context_start_underline = false,
        },
      },
    }

    vim.cmd [[ colorscheme monokai-pro-classic ]]

    -- Plugin-defined highlights (gitsigns, neo-tree, etc.) can be initialised
    -- after the colorscheme loads, overwriting our overrides.  Re-apply them
    -- from both ColorScheme (handles :colorscheme reloads) and VimEnter (runs
    -- once after every startup plugin has finished initialising).
    local function apply_custom_highlights()
      local ok, scheme = pcall(function() return require('monokai-pro').get_scheme() end)
      if not ok or not scheme then return end

      vim.api.nvim_set_hl(0, 'GitSignsUntracked', { fg = scheme.base.cyan })
      vim.api.nvim_set_hl(0, 'NeoTreeGitUntracked', { fg = scheme.base.cyan })
      vim.api.nvim_set_hl(0, 'Whitespace', { fg = scheme.base.dimmed4 })
    end

    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'monokai-pro*',
      callback = function() vim.schedule(apply_custom_highlights) end,
    })

    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function() vim.schedule(apply_custom_highlights) end,
    })
  end,
}
