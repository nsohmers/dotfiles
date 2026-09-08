# Dotfiles

---

## How to use on a new machine

```bash
# 1. Homebrew itself isn't in the Brewfile (chicken-and-egg) — install it first if needed:
#    https://brew.sh

git clone https://github.com/nsohmers/dotfiles.git ~/dotfiles
cd ~/dotfiles

brew bundle          # installs stow, neovim, tmux, and everything else in Brewfile (for mac ofc)
stow */              # symlinks every package into $HOME
# NOTE: this is a deliberate no-op for firefox/ (a .stow-local-ignore prevents it) —
# Firefox profile paths aren't stow-portable. See firefox/README.md to wire that up.

# tmux's plugin manager doesn't bootstrap itself — one manual step:
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# then, inside a tmux session: prefix + I

# Neovim bootstraps its own plugin manager (lazy.nvim) automatically on first launch.
```

---

## Docs

- [AGENTS.md](AGENTS.md) — for anyone (human or AI agent) making changes to this repo: how it's
  deployed, how to verify changes, conventions, and machine-specific gotchas
- [KEYBINDINGS.md](KEYBINDINGS.md) — every current Neovim and tmux binding, grouped by purpose
- [TMUX.md](TMUX.md) — a from-scratch tmux walkthrough for this specific setup
