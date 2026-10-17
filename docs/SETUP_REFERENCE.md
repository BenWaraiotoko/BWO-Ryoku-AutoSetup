# BWO-Ryoku-AutoSetup

Personal post-install customization layer for [Ryoku](https://ryoku.dev) — a hand-built Arch Linux desktop (Hyprland ⇄ niri) by Carlos/neur0map.

This project installs extra packages and personal dotfiles **on top of** a working Ryoku installation, mirroring the workflow from [BWO-MacAutoSetup](https://github.com/BenWaraiotoko/BWO-MacAutoSetup) but adapted for Linux/Ryoku.

> **History**: this repo is the transposition of [BWO_Omarchy_AutoSetup](https://github.com/BenWaraiotoko/BWO_Omarchy_AutoSetup) — kept for reference. The Omarchy layer was retired when the daily driver moved from Omarchy to Ryoku (Oct 2026). The Omarchy-specific parts (Ghostty binding hack, omarchy-nvim merge, alacritty) are gone; the personal layer survives, recomputed against Ryoku's base.

## Acknowledgments

- [ryoku-dev/ryoku](https://github.com/ryoku-dev/ryoku) — the foundation this builds on
- [BenWaraiotoko/BWO-MacAutoSetup](https://github.com/BenWaraiotoko/BWO-MacAutoSetup) — the macOS counterpart (source of the npm/VS Code manifests)
- [BenWaraiotoko/BWO_Omarchy_AutoSetup](https://github.com/BenWaraiotoko/BWO_Omarchy_AutoSetup) — the predecessor (archived, still readable)

---

## What This Adds

On top of everything Ryoku already provides (the 90-package base: Hyprland/niri shell, kitty, fish+zsh+starship, bat/eza/fd/fzf/ripgrep/zoxide, neovim, lazygit, btop, yazi, chromium, firefox, zen-browser, spotify, flatpak, go, nodejs, python, mise, yay, ffmpeg, snapshots snapper, etc.), this setup adds:

**Dev & Infra** — `docker`, `lazydocker`, `aws-cli-v2`, `kubectl`, `ansible`, `hugo`, `nmap`, `tmux`, `htop`

**CLI niceties** — `lazysql`, `go-yq`, `git-delta`, `csvlens`, `glow`, `chafa`, `tree`, `wget`, `rsync`, `pandoc`, `shellcheck`, `stow`

**AI tooling** — `ollama`, `opencode`, `rtk`, Claude Code (npm), SuperClaude framework (pipx)

**Apps** — `obsidian`, `zed`, VS Code (+ 56 extensions), `sublime-text-4`, `vlc`, `discord`, `notion`, `drawio`, 1Password + CLI, Proton VPN + Mail bridge, `arduino-ide`, `balena-etcher`

**npm globals** — Claude Code, gemini-cli, MCP servers (playwright, brave-search, filesystem, github, notion), ts-node — full manifest in [`npm-list.txt`](npm-list.txt)

**Dotfiles** — fish aliases + exports (`conf.d`), nvim plugins, SuperClaude commands, Zed config, vim minimal config, Obsidian vault settings

**What is deliberately NOT ported from the Mac setup**: macOS-only tools (mas, raycast, rectangle, xcodegen, orbstack — Linux runs real Docker), and everything Omarchy-specific.

## Usage

Run this AFTER Ryoku is installed:

```bash
git clone https://github.com/BenWaraiotoko/BWO-Ryoku-AutoSetup.git ~/Projects/BWO-Ryoku-AutoSetup
cd ~/Projects/BWO-Ryoku-AutoSetup
./install.sh
```

Idempotent: re-running skips what's already in place. Package installs use `yay -S --needed`.

## The Fish/Bash note

Ryoku's default shell is **fish** (zsh+starship also available). The aliases live in `dotfiles/fish/bwo-aliases.fish` and install to `~/.config/fish/conf.d/`. If you switch to zsh, the bash versions from the Omarchy repo still translate one-to-one (`alias` syntax is identical; the Omarchy `bwo-aliases.bash` needed only `command -v` → `type -q`).

## Docs

- [`docs/VIM_LEARNING_GUIDE.md`](docs/VIM_LEARNING_GUIDE.md) — Vim/Neovim learning path
- [`bwo-packages.txt`](bwo-packages.txt) — the package delta, commented
- [`vscode-extensions.txt`](vscode-extensions.txt) — the 56 VS Code extensions
- [`npm-list.txt`](npm-list.txt) — npm global manifest

## The Ryoku base (for context)

| What | Ryoku provides |
|------|----------------|
| Compositor | Hyprland ⇄ niri, switch live (`ryoku wm use niri`) |
| Shell UI | Quickshell (one Go daemon, no polling scripts) |
| Terminal | kitty |
| Shell | fish (default), zsh + starship |
| Theming | matugen — recolors everything from the wallpaper |
| Updates | `ryoku update` (snapshot → update → reload) |
| Rollback | `ryoku rollback` + boot menu snapshots |
| Settings | Ryoku Hub (`Mod+,`) — 196 settings in the UI |

---

*Built with bash, pacman/yay, and a preference for not repeating the mistakes of the previous distro. Runs on Arch via Ryoku.*