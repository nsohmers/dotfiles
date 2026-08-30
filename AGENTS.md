# AGENTS.md

Personal macOS dotfiles, managed with GNU Stow. Each top-level directory is a stow "package"
that mirrors `$HOME` (e.g. `nvim/.config/nvim/...` → `~/.config/nvim/...`). If you're an agent
working in this repo, read this before editing — most of what trips people up here isn't in the
code, it's in how the pieces are actually deployed and tested.

## Applying changes (there is no build step, but there is a deploy step)

Editing a file in this repo does **not** update the live config — it has to be symlinked in via
stow, and some tools need a one-time manual bootstrap stow doesn't cover:

```bash
brew bundle              # installs everything in Brewfile
stow */                  # symlinks every package into $HOME (re-run after adding new files)
```

- **Neovim** bootstraps itself: `lazy.nvim` is cloned automatically on first launch, then installs
  every plugin declared in `nvim/.config/nvim/lua/nsohmers/plugins/**`.
- **tmux's plugin manager (TPM) does not bootstrap itself** — it has to be cloned manually
  (`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`), then `prefix+I` inside a
  running tmux session to fetch `@plugin` entries. This is a known gap: a fresh machine does not
  get a fully working tmux from `stow */` alone. Worth scripting into a real bootstrap script if
  this repo ever needs to survive a from-scratch machine setup unattended.
- **Mason** (LSP servers, formatters) installs its own binaries into
  `~/.local/share/nvim/mason/`, driven by `ensure_installed` lists in
  `nvim/.config/nvim/lua/nsohmers/plugins/lsp/mason.lua` and `.../plugins/formatting.lua`
  (`mason-tool-installer.nvim`). **This needs Node (`npm`) on `PATH`** — several of the most
  common LSP/formatter packages (pyright, prettier) are npm-distributed, and that's already bitten
  this exact setup once (see Gotchas).

## Verification loop

There's no test suite — verification means actually loading the config and checking it doesn't
error, ideally without touching whatever the user currently has running.

**Neovim**, safe/isolated (won't touch the user's real plugin state or lockfile if you redirect
`XDG_DATA_HOME`/`XDG_STATE_HOME`/`XDG_CACHE_HOME` — but leave `XDG_CONFIG_HOME` pointed at the
real repo path so it reads the actual plugin specs):
```bash
nvim --headless "+Lazy! sync" +qa 2>&1 | grep -i error   # plugin install, catches spec errors
nvim --headless -c 'edit somefile.ts' -c 'lua vim.wait(500)' \
     -c 'lua print(vim.fn.execute("messages"))' -c 'qa'  # catches runtime/config errors
```
A plain headless run without opening a real buffer will show false-positive warnings for anything
gated behind `event = { "BufReadPre", "BufNewFile" }` (most LSP/treesitter/completion plugins) —
always open a real file with the right filetype before trusting a health check or error absence.

**tmux**, isolated (won't disturb any session the user has running):
```bash
tmux -f tmux/.tmux.conf -L scratch-test new-session -d -s t
tmux -L scratch-test show-options -g <option>   # or list-keys -T root, etc.
tmux -L scratch-test kill-server
```

**`:checkhealth`** after any plugin-layer change — it catches missing binaries, deprecated config,
and provider issues before they surface mid-task. Read the actual report, not just the exit code;
several sections (image preview, luarocks, language providers) are expected to show warnings that
aren't real problems on this machine (see Gotchas).

## Conventions

- **Keybindings are muscle memory — preserve their *feel* even when swapping the plugin behind
  them.** When migrating a plugin, keep the same `lhs` if at all reasonable (e.g. `harpoon` →
  `grapple.nvim` kept `<leader>1-9`/`h`/`m`/`n`/`p`; `nvim-surround` → `mini.surround` was
  explicitly remapped to `ys`/`cs`/`ds` because that's the muscle memory, even though mini's own
  default is `sa`/`sd`/`sr`).
- **Any genuinely new or changed keybinding gets called out explicitly**, not buried in a diff —
  the user has asked for this directly. Update [KEYBINDINGS.md](KEYBINDINGS.md) in the same change.
- **Never stack two tools in the same job.** If a plugin swap would leave two things doing the same
  work (e.g. `mini.ai` and `nvim-treesitter-textobjects` both providing `af`/`if`), resolve it —
  don't just add the new one alongside the old.
- Don't add plugins/binaries/automation beyond what's asked. Several things from "The Ultimate Dev
  Setup" doc this config is loosely based on were deliberately **not** added (`nvim-dap`, `treesj`,
  `git rerere`/`absorb`, the broader CLI baseline like `delta`/`atuin`/`mise`) — ask before adding
  scope, don't assume more is better.
- Lua files: no comments except where they explain a genuinely non-obvious *why* (a workaround, a
  deliberate trade-off, a gotcha). Don't describe what the code obviously does.

## Machine-specific gotchas (not obvious from reading the config alone)

- **AeroSpace (the WM) owns plain `alt-h/j/k/l`** for switching focus between OS windows — that
  grab happens before Ghostty (or anything inside it) ever sees the keystroke. This is why tmux
  pane nav and `vim-tmux-navigator` use **`Ctrl+Alt+h/j/k/l`** instead of plain Alt. See
  `tmux/.tmux.conf` and `nvim/.../plugins/init.lua`.
- **`Ctrl+Alt+<letter>` has no unambiguous legacy terminal escape sequence.** `tmux.conf` sets
  `extended-keys always` to force modern CSI-u key reporting from Ghostty — without it, that combo
  silently does nothing (or collides with something else) even though the tmux/nvim bindings look
  correct on paper. If pane-nav ever "stops working" again after a config change, check this
  setting and `Ghostty`'s support for it before assuming the binding itself is wrong.
- Ghostty needs `macos-option-as-alt = true` (set in `ghostty/.config/ghostty/config`) for plain
  `Alt`/`Option` combos to work as Meta anywhere at all — without it, macOS composes accented
  characters instead.
- **`mason-lspconfig`'s `ensure_installed` silently no-ops when Neovim runs headless** (checked via
  `platform.is_headless` in its own source) — don't trust a clean headless run as proof that LSP
  servers/formatters actually installed. Check `~/.local/share/nvim/mason/packages/` or
  `~/.local/state/nvim/mason.log` directly, or just launch real interactive Neovim.
- `snacks.image`'s "terminal doesn't support kitty graphics protocol" health check can't pass in a
  headless test (no real TTY) regardless of whether Ghostty actually supports it — verify that one
  from inside a real Ghostty+Neovim session, not headless.
- `tmux-sessionizer` (`tmux/.local/bin/tmux-sessionizer`) has hardcoded `SEARCH_ROOTS` — currently
  `~/dotfiles` and `~/Documents` because that's what actually exists on this machine (`~/Dev`,
  referenced by the old harpoon-era `auto-session` config, does not exist here). Update it if the
  project layout changes.

## Where to look first

- [KEYBINDINGS.md](KEYBINDINGS.md) — every current nvim/tmux binding, grouped by purpose
- [TMUX.md](TMUX.md) — a from-scratch tmux walkthrough for this specific setup
- [README.md](README.md) — stow usage, one line
- `nvim/.config/nvim/lua/nsohmers/plugins/` — one file per plugin, `lsp/` subfolder for LSP-specific
  config
