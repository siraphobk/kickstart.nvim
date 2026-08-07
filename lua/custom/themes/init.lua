-- [[ Theme registry ]]
--
-- Every colorscheme lives in this directory, one file each, and every one of
-- them is installed and configured at startup.  That is what makes plain
-- `:colorscheme <Tab>` able to switch between them instantly -- a theme's
-- `setup()` only stores options, it does not paint anything, so priming all of
-- them is cheap.
--
-- To add a theme:
--   1. Drop a file in this directory returning { src = ..., config = ... }.
--   2. Add its colorscheme name to `M.themes` below.
--
-- To change the theme you start in: edit `M.default` below.  Switching with
-- `:colorscheme` is session-only by design; this line is the durable choice.

local M = {}

--- Module name -> colorscheme name, in load order.
--- The module `custom.themes.<name>` must exist for each entry.
M.themes = {
  'gruvbox-material',
  'luna',
  'monokai-pro',
  'tokyonight',
}

--- The colorscheme applied at startup.  Must be one of `M.themes`.
M.default = 'luna'

-- Collect the specs first so every theme installs in a single `vim.pack.add`
-- call -- on a fresh machine that is one download pass instead of one per theme.
local srcs, configs = {}, {}
for _, name in ipairs(M.themes) do
  local ok, theme = pcall(require, 'custom.themes.' .. name)
  if ok then
    table.insert(srcs, theme.src)
    table.insert(configs, theme.config)
  else
    vim.notify(('theme %q failed to load: %s'):format(name, theme), vim.log.levels.ERROR)
  end
end

vim.pack.add(srcs)

-- Run each theme's config only after all of them are on the runtimepath, so a
-- config that reaches for another plugin's module cannot lose a race.
for _, config in ipairs(configs) do
  local ok, err = pcall(config)
  if not ok then vim.notify(('theme config failed: %s'):format(err), vim.log.levels.ERROR) end
end

-- A broken theme should leave you on Neovim's default scheme, not in a
-- half-highlighted buffer with no way to read the error.
local ok, err = pcall(vim.cmd.colorscheme, M.default)
if not ok then vim.notify(('colorscheme %q failed: %s'):format(M.default, err), vim.log.levels.ERROR) end

return M
