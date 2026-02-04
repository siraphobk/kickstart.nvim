# Agent Guide for This Neovim Config

This repository is a Kickstart-based Neovim configuration. It is Lua-first and uses lazy.nvim
for plugin management. This guide is for agentic tools working in this repo.

## Repo Orientation
- Entry point: `init.lua`
- Plugin specs: `lua/kickstart/plugins/*.lua` and `lua/custom/plugins/*.lua`
- Formatting config: `.stylua.toml`
- Plugin lockfile: `lazy-lock.json`

## Build / Lint / Test Commands

There is no traditional build or test suite in this repo. Use the commands below instead.

### Health / Diagnostics
- Run Neovim healthcheck (headless):
  - `nvim --headless "+checkhealth" +qa`
- Check Lazy plugin status (interactive):
  - `:Lazy` inside Neovim

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
- Use lazy.nvim plugin specs in `init.lua` or `lua/custom/plugins/*.lua`.
- Keep custom plugins isolated in `lua/custom/plugins` to reduce merge conflicts.
- Avoid manual edits to `lazy-lock.json` unless you are intentionally updating lock state.

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
- `lua/kickstart/plugins/*.lua`: optional plugin modules included by Kickstart
- `.stylua.toml`: Lua formatter configuration

## Notes for Agents
- This is a personal config repo; avoid large refactors unless requested.
- Prefer minimal, targeted changes that fit existing patterns.
- When modifying keymaps or options, check for conflicts in `init.lua`.
