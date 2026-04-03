return {
  'jake-stewart/multicursor.nvim',
  branch = '1.0',
  config = function()
    local mc = require 'multicursor-nvim'
    mc.setup()

    local set = vim.keymap.set

    -- Add or skip cursor above/below the main cursor.
    set({ 'n', 'x' }, '<up>', function() mc.lineAddCursor(-1) end, { desc = 'MC: Add cursor above' })
    set({ 'n', 'x' }, '<down>', function() mc.lineAddCursor(1) end, { desc = 'MC: Add cursor below' })
    set({ 'n', 'x' }, '<leader>m<up>', function() mc.lineSkipCursor(-1) end, { desc = 'MC: Skip cursor above' })
    set({ 'n', 'x' }, '<leader>m<down>', function() mc.lineSkipCursor(1) end, { desc = 'MC: Skip cursor below' })

    -- Add or skip adding a new cursor by matching word/selection
    set({ 'n', 'x' }, '<leader>mn', function() mc.matchAddCursor(1) end, { desc = 'MC: Match add cursor (forward)' })
    set({ 'n', 'x' }, '<leader>ms', function() mc.matchSkipCursor(1) end, { desc = 'MC: Match skip cursor (forward)' })
    set({ 'n', 'x' }, '<leader>mN', function() mc.matchAddCursor(-1) end, { desc = 'MC: Match add cursor (backward)' })
    set({ 'n', 'x' }, '<leader>mS', function() mc.matchSkipCursor(-1) end, { desc = 'MC: Match skip cursor (backward)' })

    -- Add and remove cursors with control + left click.
    set('n', '<c-leftmouse>', mc.handleMouse, { desc = 'MC: Toggle cursor' })
    set('n', '<c-leftdrag>', mc.handleMouseDrag, { desc = 'MC: Drag cursor' })
    set('n', '<c-leftrelease>', mc.handleMouseRelease, { desc = 'MC: Release cursor' })

    -- Disable and enable cursors.
    set({ 'n', 'x' }, '<c-q>', mc.toggleCursor, { desc = 'MC: Toggle cursor' })

    -- Mappings defined in a keymap layer only apply when there are
    -- multiple cursors. This lets you have overlapping mappings.
    mc.addKeymapLayer(function(layerSet)
      -- Select a different cursor as the main one.
      layerSet({ 'n', 'x' }, '<left>', mc.prevCursor, { desc = 'MC: Previous cursor' })
      layerSet({ 'n', 'x' }, '<right>', mc.nextCursor, { desc = 'MC: Next cursor' })

      -- Delete the main cursor.
      layerSet({ 'n', 'x' }, '<leader>mx', mc.deleteCursor, { desc = 'MC: Delete cursor' })

      -- Enable and clear cursors using escape.
      layerSet('n', '<esc>', function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        else
          mc.clearCursors()
        end
      end, { desc = 'MC: Enable/clear cursors' })
    end)

    -- Customize how cursors look.
    local hl = vim.api.nvim_set_hl
    hl(0, 'MultiCursorCursor', { reverse = true })
    hl(0, 'MultiCursorVisual', { link = 'Visual' })
    hl(0, 'MultiCursorSign', { link = 'SignColumn' })
    hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
    hl(0, 'MultiCursorDisabledCursor', { reverse = true })
    hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
    hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
  end,
}
