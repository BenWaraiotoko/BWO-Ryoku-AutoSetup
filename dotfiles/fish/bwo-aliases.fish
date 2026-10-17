# BWO Fish Aliases for Ryoku
# Source: ~/.config/fish/bwo-aliases.fish
# Ryoku's default shell is fish (with zsh+starship available).

# ─────────────────────────────────────────────────────────────
# eza — modern ls (preinstalled in Ryoku)
# ─────────────────────────────────────────────────────────────
if type -q eza
  alias ls="eza --icons"
  alias ll="eza -la --icons --git"
  alias lt="eza --tree --level=2 --icons"
  alias la="eza -a --icons"
end

# ─────────────────────────────────────────────────────────────
# Git shortcuts
# ─────────────────────────────────────────────────────────────
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline --graph --decorate"
alias gd="git diff"

# ─────────────────────────────────────────────────────────────
# Navigation
# ─────────────────────────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ─────────────────────────────────────────────────────────────
# Editors
# ─────────────────────────────────────────────────────────────
alias v="nvim"
alias nv="nvim"

# ─────────────────────────────────────────────────────────────
# Claude Code (npm-installed binary is `claude`)
# ─────────────────────────────────────────────────────────────
# Ryoku has no ghostty/alacritty binding hacks — Mod+Return opens kitty

# ─────────────────────────────────────────────────────────────
# Docker / Containers
# ─────────────────────────────────────────────────────────────
if type -q docker
  alias d="docker"
  alias dc="docker compose"
  alias dps="docker ps"
  alias dpa="docker ps -a"
end

# ─────────────────────────────────────────────────────────────
# System (pacman/yay — the rules of the gold table still apply)
# ─────────────────────────────────────────────────────────────
alias pkgup="yay -Syu --noconfirm"     # Full system upgrade (snapshot auto via Ryoku)
alias pkgin="yay -S --needed"          # Install package
alias pkgs="yay -Ss"                   # Search packages
alias pkginfo="yay -Qi"                # Package info
alias pkgrm="yay -Rns"                 # Remove package + deps

# ─────────────────────────────────────────────────────────────
# bat — better cat (preinstalled in Ryoku)
# ─────────────────────────────────────────────────────────────
if type -q bat
  alias cat="bat --style=plain"
  alias catn="bat"
end