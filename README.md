# 🍜 BWO-Ryoku-AutoSetup

> A fresh install of Ryoku, one script, a coffee ☕… and by the time you're back, your machine is *yours*.

![Ryoku](https://img.shields.io/badge/Base-Ryoku%20(Arch)-EB6D3C?logo=archlinux&logoColor=white)
![Shell](https://img.shields.io/badge/Shell-fish%20%2B%20zsh-1A2C34?logo=linuxsh&logoColor=white)
![Packages](https://img.shields.io/badge/Extra%20packages-35%2B-FBB040?logo=pacman&logoColor=black)
![Status](https://img.shields.io/badge/status-work--in--progress-orange)

So here's the thing — I used to run Omarchy. Great distro on paper: Arch, Hyprland, keyboard-first, all the right buzzwords. Then I read what its creator had been writing for years, and no amount of good defaults is worth shrugging at that. So I left. No drama, no angry blog post — just a new home for my config.

That new home is [**Ryoku**](https://ryoku.dev): a hand-built Arch desktop by one indie dev (Carlos, a.k.a. neur0map), with a shell that runs as a single Go daemon instead of a pile of polling scripts, theming that recolors your whole desktop from your wallpaper, and Hyprland ⇄ niri switching without a reinstall. And since every fresh install means an afternoon of "wait, which packages did I need again?" — this repo is my answer.

**One script turns a stock Ryoku install into my machine**: my dev tools, my CLI niceties, my AI stack, my 56 VS Code extensions, my dotfiles. All declarative, all idempotent, all re-runnable.

## 🚀 The One Command

You're on a fresh Ryoku box (if not: [ryoku.dev](https://ryoku.dev), the installer is a delight):

```bash
git clone https://github.com/BenWaraiotoko/BWO-Ryoku-AutoSetup.git ~/Projects/BWO-Ryoku-AutoSetup
cd ~/Projects/BWO-Ryoku-AutoSetup
./install.sh
```

Go make that coffee. When you're back:

- ~35 extra packages installed (docker, lazydocker, kubectl, ansible, hugo, tmux, git-delta, lazysql, glow, csvlens, 1Password, Obsidian, Zed, VS Code, VLC, Discord, Notion, drawio, Proton VPN, ollama, opencode…)
- Claude Code + 10 npm globals (MCP servers included)
- 56 VS Code extensions via `code --install-extension`
- SuperClaude framework (30+ slash commands for Claude Code)
- Fish aliases & exports (`ls` → `eza`, `cat` → `bat`, git/docker/pacman shortcuts — the classics)
- Neovim plugins, Zed config, minimal vim config, Obsidian vault settings

Re-run it anytime: everything already in place is skipped (`yay -S --needed`, file-exists checks). A setup script that breaks halfway through is worse than no script at all — this one picks up where it left off.

## 🧠 The Idea: Delta, Not Kitchen Sink

Ryoku already ships 90 packages — a complete desktop: fish, zsh, starship, bat, eza, fd, fzf, ripgrep, zoxide, neovim, lazygit, btop, yazi, kitty, chromium, firefox, zen-browser, spotify, flatpak, go, nodejs, python, mise, ffmpeg, snapper snapshots around every pacman… The works.

So this repo does **not** reinstall the world. It computes the delta between "stock Ryoku" and "my machine" and installs exactly that. Want to see the reasoning? Every line of [`bwo-packages.txt`](bwo-packages.txt) is commented with what it's for and why it's not in the base.

Same philosophy on the macOS side: my [Mac setup](https://github.com/BenWaraiotoko/BWO-MacAutoSetup) recently taught me that a declarative package list only stays honest if you subtract as deliberately as you add. This repo starts honest: it's a delta against a base that's already generous.

## 📦 What's Inside

| File | What |
|------|------|
| `install.sh` | The conductor — packages, npm globals, VS Code extensions, dotfiles |
| [`bwo-packages.txt`](bwo-packages.txt) | The delta: ~35 packages, each commented |
| [`vscode-extensions.txt`](vscode-extensions.txt) | The 56 VS Code extensions, extracted from my Mac Brewfile |
| [`npm-list.txt`](npm-list.txt) | npm global manifest (Claude Code, gemini-cli, MCP servers) |
| `dotfiles/fish/` | Aliases + exports for fish (Ryoku's default shell) |
| `dotfiles/nvim/` | LazyVim plugin additions (catppuccin, beginner tweaks) |
| `dotfiles/superclaude/` | SuperClaude slash commands |
| `dotfiles/zed/`, `dotfiles/vim/`, `dotfiles/obsidian/` | The rest of the config layer |
| [`docs/`](docs/) | SETUP_REFERENCE (full inventory), VIM_LEARNING_GUIDE |

## 🗺️ Family Portrait

This repo is one of three:

- **[BWO-MacAutoSetup](https://github.com/BenWaraiotoko/BWO-MacAutoSetup)** — the macOS twin (one command, blank Mac → done)
- **This repo** — the Linux/Ryoku twin
- **BWO_Omarchy_AutoSetup** — the predecessor, now private — kept for reference and for the memories. It taught me the pattern this repo repeats better.

Same idea everywhere: declarative packages, idempotent scripts, dotfiles in the repo, re-runnable forever. The OS changes; the philosophy doesn't.

## 🎭 The Philosophy

- **Delta over kitchen sink** — install what the base lacks, not what a blog post said
- **Idempotent or useless** — a script you fear re-running is a script you won't run
- **fish is the default, and that's fine** — `;and` instead of `&&` is a small toll for a shell that suggests commands as you type
- **The repo is the machine** — if it's not in here, it doesn't exist on a fresh install

## ⚡ Status

Built on 2026-10-17 against **Ryoku v0.75.5-beta**. The **1.0 "Amaterasu" lands Oct 26** — the plan is to do the fresh install on the 1.0 ISO, run this script on day one, and update the delta if anything drifted. Expect the first "real world" commit shortly after that.

---

*Built with bash, pacman/yay, and a strong preference for distros whose creators don't make the news for the wrong reasons. Runs on Arch, via Ryoku.*