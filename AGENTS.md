# Agent Guide for This Neovim Config

This repository is a Kickstart-based Neovim configuration. It is Lua-first and uses Neovim's
built-in `vim.pack` for plugin management (it was migrated off lazy.nvim). This guide is for
agentic tools working in this repo.

## Repo Orientation
- Entry point: `init.lua`
- Plugin specs: `lua/kickstart/plugins/*.lua` and `lua/custom/plugins/*.lua`
- Colorschemes: `lua/custom/themes/` (see Themes below)
- Formatting config: `.stylua.toml`
- Plugin lockfile: `nvim-pack-lock.json` — gitignored, so it is local state, not tracked

## Build / Lint / Test Commands

There is no traditional build or test suite in this repo. Use the commands below instead.

### Health / Diagnostics
- Run Neovim healthcheck (headless):
  - `nvim --headless "+checkhealth" +qa`
- Check plugin status (interactive, inside Neovim):
  - `:PackList` — list installed plugins
  - `:PackUpdate [name...]` — fetch updates and review them (`:write` applies)
  - `:PackPreview [name...]` — same view, offline, no network
  - `:PackReinstall <name>` — delete and re-clone one plugin
  - `:PackNuke` — delete all plugins from disk; restart to reinstall

### Formatting (Lua)
- Format all Lua files with StyLua:
  - `stylua .`
- Format a single file:
  - `stylua path/to/file.lua`

### Linting
- Linting is configured via `nvim-lint` and runs in-editor on buffer events.
- For Markdown, `markdownlint` is the configured linter.
- There is no repository-level CLI lint command; use in-editor linting or run the linter
  directly, e.g. `markdownlint path/to/file.md` if installed.

### Tests
- No automated test suite is present.
- Single-test execution: not applicable.

## Code Style Guidelines

### Lua Formatting (from `.stylua.toml`)
- Indentation: 2 spaces (no tabs)
- Column width: 160
- Line endings: Unix
- Quotes: prefer single quotes when possible
- Call parentheses: omit when possible (Lua style)
- Collapse simple statements when possible

### Imports and Module Structure
- Prefer local requires at top of file:
  - `local telescope = require 'telescope'`
- Use single quotes for module names: `require 'module.name'`
- Avoid global variables; use `local` for everything not explicitly global.
- Use `pcall` for optional integrations (e.g. plugin extensions).

### Naming Conventions
- Local variables and functions: `snake_case`
- Modules: `local M = {}` with `return M`
- Plugin specs: plain Lua tables returned from module files
- Keymaps and options: use descriptive names and `desc` where possible

### Error Handling and Safety
- Prefer early return on missing conditions (e.g. `if not has_feature then return end`).
- Use `pcall` for optional or external dependencies to avoid hard failures.
- Use `vim.notify` for user-facing errors when appropriate (avoid noisy `print`).

### Plugin Management
- Install with `vim.pack.add { 'https://github.com/owner/repo' }`, then configure right below it.
  Inside `init.lua` use the `gh 'owner/repo'` helper; files under `lua/custom/` are outside its
  scope, so they spell the URL out.
- Keep custom plugins isolated in `lua/custom/plugins` to reduce merge conflicts. Every `*.lua`
  file there is auto-loaded by `lua/custom/plugins/init.lua`, which uses `dofile` rather than
  `require` so filenames containing dots (e.g. `aerial.nvim.lua`) still work.
- Do not edit `nvim-pack-lock.json` by hand; it is generated and gitignored.

### Themes
- Every colorscheme lives in `lua/custom/themes/`, one file per theme, each returning
  `{ src = '<git url>', config = function() ... end }`.
- `lua/custom/themes/init.lua` is the registry: `M.themes` lists them, `M.default` names the one
  applied at startup. It installs all of them in a single `vim.pack.add` call, runs each
  `config()`, then applies the default.
- A theme's `config()` must never call `vim.cmd.colorscheme` — only the registry activates a
  theme, so load order cannot decide which one wins. Put `setup()` calls, `vim.g.*` options, and
  `ColorScheme` autocmds for highlight overrides inside `config()`.
- All themes are primed at startup, so `:colorscheme <name>` switches instantly. That switch is
  session-only; changing the startup theme means editing `M.default`.
- To add a theme: add the file, then add its name to `M.themes`.

### Configuration Style
- Keep options grouped by function (options, keymaps, LSP, UI, etc.).
- Document non-obvious settings with short comments only when necessary.
- Keep keymaps consistent with existing patterns (leader-based, descriptive `desc`).

### LSP / Completion
- LSP is configured in `init.lua` using `nvim-lspconfig` and `mason`.
- Completion is via `saghen/blink.cmp` with sources defined under `opts.sources`.
- When adding a completion source, keep it scoped to `opts.sources.providers` and
  use a deterministic `score_offset` if needed.

## Cursor / Copilot Rules
- No `.cursor/rules/`, `.cursorrules`, or `.github/copilot-instructions.md` were found.
- If any are added later, update this guide to reflect them.

## Common Files to Know
- `init.lua`: primary configuration and plugin setup
- `lua/custom/plugins/*.lua`: your personal plugin specs
- `lua/custom/themes/*.lua`: colorschemes, plus the registry in `init.lua`
- `lua/kickstart/plugins/*.lua`: optional plugin modules included by Kickstart
- `.stylua.toml`: Lua formatter configuration

## Notes for Agents
- This is a personal config repo; avoid large refactors unless requested.
- Prefer minimal, targeted changes that fit existing patterns.
- When modifying keymaps or options, check for conflicts in `init.lua`.
