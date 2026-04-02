return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  init = function()
    -- Disable built-in ftplugin mappings to avoid conflicts
    vim.g.no_plugin_maps = true
  end,
  config = function()
    require('nvim-treesitter-textobjects').setup {
      select = {
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v',
          ['@function.outer'] = 'V',
          ['@class.outer'] = 'V',
        },
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
    }

    -- Select text objects
    vim.keymap.set(
      { 'x', 'o' },
      'af',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end,
      { desc = 'Select around function' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'if',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end,
      { desc = 'Select inner function' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'ac',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end,
      { desc = 'Select around class' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'ic',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end,
      { desc = 'Select inner class' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'aa',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects') end,
      { desc = 'Select around parameter' }
    )
    vim.keymap.set(
      { 'x', 'o' },
      'ia',
      function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects') end,
      { desc = 'Select inner parameter' }
    )

    -- Swap text objects
    vim.keymap.set(
      'n',
      '<leader>tp',
      function() require('nvim-treesitter-textobjects.swap').swap_next '@parameter.inner' end,
      { desc = '[T]reesitter swap next [P]arameter' }
    )
    vim.keymap.set(
      'n',
      '<leader>tP',
      function() require('nvim-treesitter-textobjects.swap').swap_previous '@parameter.inner' end,
      { desc = '[T]reesitter swap previous [P]arameter' }
    )

    -- Move to next/previous text objects
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']f',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') end,
      { desc = 'Next function start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']]',
      function() require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects') end,
      { desc = 'Next class start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      ']F',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects') end,
      { desc = 'Next function end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '][',
      function() require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects') end,
      { desc = 'Next class end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[f',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects') end,
      { desc = 'Previous function start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[[',
      function() require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects') end,
      { desc = 'Previous class start' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[F',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects') end,
      { desc = 'Previous function end' }
    )
    vim.keymap.set(
      { 'n', 'x', 'o' },
      '[]',
      function() require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects') end,
      { desc = 'Previous class end' }
    )

    -- Repeatable movements with ; and ,
    local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'
    vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)
    -- Make f, F, t, T repeatable too
    vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
