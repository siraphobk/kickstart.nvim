-- harpoon: pin a handful of files and jump between them instantly.
-- The v2 rewrite lives on the `harpoon2` branch, not the default branch, so pin it.
-- plenary.nvim is already installed by telescope in `init.lua`, which runs first.
vim.pack.add { { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' } }

local harpoon = require 'harpoon'

harpoon:setup {
  settings = {
    -- Write the list to disk whenever the quick menu opens/closes, so a crash
    -- or a second Neovim instance cannot lose edits made in the menu.
    save_on_toggle = true,
    sync_on_ui_close = true,
  },
}

-- Mark the line for the file you are currently in when the quick menu opens, and
-- park the cursor on it, so the menu shows where you are instead of just what is
-- in the list.
harpoon:extend(require('harpoon.extensions').builtins.highlight_current_file())

local set = vim.keymap.set

set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon: [A]dd current file' })
-- Harpoon's own default for the menu is <C-e>, but neoscroll.nvim already owns
-- that for smooth scroll-down, so the menu goes on the shifted twin of add.
set('n', '<leader>A', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon: toggle quick menu' })

-- Direct jumps to the first five slots. The quick menu is the source of truth
-- for what sits in each slot; reorder there and these follow.
for slot = 1, 5 do
  set('n', '<leader>' .. slot, function() harpoon:list():select(slot) end, { desc = 'Harpoon: jump to file ' .. slot })
end

-- Cycle the list without opening the menu. Wraps at both ends.
set('n', ']h', function() harpoon:list():next { ui_nav_wrap = true } end, { desc = 'Harpoon: next file' })
set('n', '[h', function() harpoon:list():prev { ui_nav_wrap = true } end, { desc = 'Harpoon: previous file' })

-- Rarer list surgery, grouped under <leader>H.
set('n', '<leader>Hr', function() harpoon:list():remove() end, { desc = 'Harpoon: [R]emove current file' })
set('n', '<leader>Hc', function() harpoon:list():clear() end, { desc = 'Harpoon: [C]lear list' })

-- [[ Telescope picker ]]
-- This does not replace the quick menu above -- the menu is a real buffer, so it
-- is the only place that can reorder the list. The picker covers the other half:
-- fuzzy filtering with a file preview once the list outgrows five slots.
local has_telescope, pickers = pcall(require, 'telescope.pickers')
if has_telescope then
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'

  -- Removing a middle entry leaves a nil hole -- harpoon only shrinks its length
  -- when the *last* slot goes. So `ipairs(list.items)` stops at the first hole and
  -- silently hides everything after it. Walk the real length and skip holes.
  local function harpoon_entries(list)
    local entries = {}
    for slot = 1, list:length() do
      local item = list.items[slot]
      if item ~= nil then entries[#entries + 1] = { slot = slot, value = item.value, context = item.context } end
    end
    return entries
  end

  local function harpoon_finder(list)
    return finders.new_table {
      results = harpoon_entries(list),
      entry_maker = function(entry)
        return {
          value = entry,
          ordinal = entry.value,
          -- Show the slot number: it is the digit in <leader>1..5.
          display = string.format('%d  %s', entry.slot, entry.value),
          path = vim.fn.fnamemodify(entry.value, ':p'),
          lnum = entry.context and entry.context.row or nil,
        }
      end,
    }
  end

  -- Rebuild the list from the lines that survive, which also closes up the holes
  -- so the <leader>1..5 slots stay dense. Same call the quick menu makes when you
  -- delete one of its lines.
  local function drop_slot(list, slot)
    local kept = {}
    for i, text in ipairs(list:display()) do
      if i ~= slot and text ~= '' then kept[#kept + 1] = text end
    end
    list:resolve_displayed(kept, #kept)
    harpoon:sync()
  end

  local function open_picker()
    local list = harpoon:list()
    pickers
      .new({}, {
        prompt_title = 'Harpoon',
        finder = harpoon_finder(list),
        sorter = conf.generic_sorter {},
        previewer = conf.file_previewer {},
        attach_mappings = function(prompt_bufnr, map)
          -- Open through harpoon rather than letting telescope edit the file, so
          -- harpoon's cursor lands on that slot and ]h / [h carry on from there.
          actions.select_default:replace(function()
            local entry = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if entry then list:select(entry.value.slot) end
          end)

          -- <C-x> drops the highlighted file from the list, picker stays open.
          map({ 'i', 'n' }, '<C-x>', function()
            local entry = action_state.get_selected_entry()
            if not entry then return end
            drop_slot(list, entry.value.slot)
            action_state.get_current_picker(prompt_bufnr):refresh(harpoon_finder(list), { reset_prompt = false })
          end)

          return true
        end,
      })
      :find()
  end

  -- Bound in both homes on purpose: with the rest of harpoon under <leader>H, and
  -- with the rest of the telescope pickers under <leader>s.
  set('n', '<leader>Hf', open_picker, { desc = 'Harpoon: [F]ind in list (telescope)' })
  set('n', '<leader>sH', open_picker, { desc = '[S]earch [H]arpoon list' })
end
