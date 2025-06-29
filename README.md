# My Dotfiles

This repository contains my personal configuration files ("dotfiles") managed with [GNU Stow](https://www.gnu.org/software/stow/).

---

## What’s inside?

Configs for various tools and apps including:

- `zsh` (`~/.zshrc`)
- `nvim` (`~/.config/nvim`)
- `hypr` (`~/.config/hypr`)
- `kitty` (`~/.config/kitty`)
- `tmux` (`~/.tmux.conf`)
- `wofi` (`~/.config/wofi`)
- `waybar` (`~/.config/waybar`)
- `btop` (`~/.config/btop`)
- `neofetch` (`~/.config/neofetch`)
- `nwg-look` (`~/.config/nwg-look`)
- `swaylock` (`~/.config/swaylock`)
- `wlogout` (`~/.config/wlogout`)

---

## How to use on a new machine (Once stow is installed)

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow */
```
