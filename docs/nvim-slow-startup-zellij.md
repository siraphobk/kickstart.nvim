# Slow Neovim startup + `E1568` under zellij

## Symptom

On startup Neovim prints:

```
E1568: Terminal did not respond to DSR request for 'background' color.
Startup may be slower. :help 'ttyfast'
```

and takes noticeably longer to open.

## Cause

Neovim 0.10+ auto-detects light vs. dark background. At startup it sends the
terminal an **OSC 11 / DSR** query ("what's your background color?") and blocks
waiting for the reply, using the same round-trip to decide if the tty is "fast".

Running inside **zellij** breaks this. Zellij forwards the query out to the real
terminal but does **not** relay the response back into the pane. Neovim waits
for a reply that never comes, hits its timeout, prints `E1568`, and only then
finishes starting. That timeout wait is the slow startup.

```
  Without zellij                        With zellij
  ─────────────                         ───────────
  nvim ──OSC11?──► terminal             nvim ──OSC11?──► zellij ──► terminal
       ◄──reply───                           ◄─ (nothing) ─x  (swallowed)
   fast start, no warning                    │
                                             └─ waits… times out → E1568 → slow start
```

It is harmless — Neovim still works, and dark themes resolve correctly anyway
(zellij reports the background as black).

- Not tmux- or SSH-specific here; the trigger is **zellij** in the process tree.
- Fixable only from the shell side. Zellij can't yet be configured to relay the
  OSC response (open upstream limitation).

## Fix

Skip the probe entirely with an env var (needs Neovim >= 0.12.3):

```bash
export NVIM_NOTTYFAST=1
```

Added to `~/.bashrc`. It must be an env var, not `init.lua` — Neovim reads it
*before* the config runs, so setting it in Lua is too late. Safe to export
globally: on terminals that do respond it just skips a minor optimization.

## References

- [neovim/neovim Discussion #38648 — resolving the DSR / slow-startup warning](https://github.com/neovim/neovim/discussions/38648)
- [zellij #3590 — OSC 10/11 queries report incorrect colors](https://github.com/zellij-org/zellij/issues/3590)
- [zellij #2444 — Neovim colors weird under zellij](https://github.com/zellij-org/zellij/issues/2444)
