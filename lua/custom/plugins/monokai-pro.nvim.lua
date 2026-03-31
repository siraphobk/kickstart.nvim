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

          -- Untracked files - using a cyan/teal color as example
          -- GitSignsUntracked = { fg = colors.base.cyan },
          NeoTreeGitUntracked = { fg = colors.base.cyan },
          -- You can also use hex colors directly:
          GitSignsUntracked = { fg = colors.base.cyan },

          -- Make lead/trail listchars more visible
          Whitespace = { fg = colors.base.dimmed4 },
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
  end,
}
