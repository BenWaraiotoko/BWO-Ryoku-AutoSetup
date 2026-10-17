#!/usr/bin/env bash

# BWO Ryoku AutoSetup
# Post-install customization script for Ryoku Linux (https://ryoku.dev)
# Run this AFTER Ryoku is already installed on your system.
#
# Usage:
#   git clone https://github.com/BenWaraiotoko/BWO-Ryoku-AutoSetup.git ~/Projects/BWO-Ryoku-AutoSetup
#   cd ~/Projects/BWO-Ryoku-AutoSetup
#   ./install.sh

set -eo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error()   { echo -e "${RED}❌ $1${NC}"; }
log_info()    { echo -e "ℹ️  $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verify we are on Ryoku / Arch-based system
if ! command -v yay &>/dev/null && ! command -v pacman &>/dev/null; then
  log_error "This script requires an Arch-based system with pacman/yay."
  log_error "Please run this on Ryoku Linux (https://ryoku.dev)."
  exit 1
fi

echo ""
echo "╔═══════════════════════════════════════════╗"
echo "║       BWO Ryoku AutoSetup                 ║"
echo "║  Personal customization for Ryoku Linux   ║"
echo "╚═══════════════════════════════════════════╝"
echo ""

# ─────────────────────────────────────────────────────────────
# 1. Ensure yay is available (Ryoku ships yay-bin; fallback build)
# ─────────────────────────────────────────────────────────────
if ! command -v yay &>/dev/null; then
  echo "Installing yay (AUR helper)..."
  sudo pacman -S --needed --noconfirm git base-devel
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay && makepkg -si --noconfirm
  cd "$SCRIPT_DIR"
  log_success "yay installed"
else
  log_success "yay already available"
fi

# ─────────────────────────────────────────────────────────────
# 2. Install extra packages from bwo-packages.txt
#    (delta vs the 90-package Ryoku base manifest)
# ─────────────────────────────────────────────────────────────
PACKAGES_FILE="$SCRIPT_DIR/bwo-packages.txt"
if [[ -f "$PACKAGES_FILE" ]]; then
  echo "Installing extra packages from bwo-packages.txt..."
  mapfile -t PACKAGES < <(grep -v '^\s*#' "$PACKAGES_FILE" | grep -v '^\s*$' | sed 's/\s*#.*//' | awk '{print $1}')
  if [[ ${#PACKAGES[@]} -gt 0 ]]; then
    yay -S --needed --noconfirm "${PACKAGES[@]}" || log_warning "Some packages failed to install — continuing"
    log_success "Extra packages installed"
  else
    log_info "No packages to install"
  fi
else
  log_warning "bwo-packages.txt not found — skipping extra package install"
fi

# ─────────────────────────────────────────────────────────────
# 3. Claude Code + npm global tools (mirrors the Mac npm list)
# ─────────────────────────────────────────────────────────────
echo "Installing npm global tools (Claude Code, MCP servers)..."
if command -v npm &>/dev/null; then
  npm install -g @anthropic-ai/claude-code 2>/dev/null || log_warning "claude-code npm install failed (try AUR claude-code)"
  for pkg in @21st-dev/magic @executeautomation/playwright-mcp-server @google/gemini-cli \
             @modelcontextprotocol/server-brave-search @modelcontextprotocol/server-filesystem \
             @modelcontextprotocol/server-github @playwright/mcp @suekou/mcp-notion-server \
             ts-node; do
    npm install -g "$pkg" 2>/dev/null || log_warning "npm $pkg failed — continuing"
  done
  log_success "npm globals installed (see npm-list.txt for the full manifest)"
else
  log_warning "npm not found — skipping npm globals"
fi

# ─────────────────────────────────────────────────────────────
# 4. VS Code extensions (the 56 from the Mac Brewfile)
# ─────────────────────────────────────────────────────────────
echo "Installing VS Code extensions from vscode-extensions.txt..."
CODE_BIN=""
if command -v code &>/dev/null; then
  CODE_BIN="code"
elif command -v codium &>/dev/null; then
  CODE_BIN="codium"
fi
if [[ -n "$CODE_BIN" && -f "$SCRIPT_DIR/vscode-extensions.txt" ]]; then
  while read -r ext; do
    [[ -z "$ext" || "$ext" =~ ^# ]] && continue
    "$CODE_BIN" --install-extension "$ext" 2>/dev/null || log_warning "ext $ext failed — continue"
  done < "$SCRIPT_DIR/vscode-extensions.txt"
  log_success "VS Code extensions installed"
else
  log_warning "VS Code CLI not found or no extension list — skipping (install code first, re-run)"
fi

# ─────────────────────────────────────────────────────────────
# 5. Install SuperClaude Framework
# ─────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

if command -v superclaude &>/dev/null; then
  log_success "SuperClaude already installed, checking for updates..."
  pipx upgrade superclaude 2>/dev/null || true
elif command -v pipx &>/dev/null; then
  echo "Installing SuperClaude Framework..."
  if pipx install superclaude; then
    if command -v superclaude &>/dev/null; then
      superclaude install
      superclaude doctor
      log_success "SuperClaude installed"
    else
      log_warning "SuperClaude installed but not in PATH yet"
      log_info "Run 'pipx ensurepath' and restart shell, then: superclaude install"
    fi
  else
    log_warning "Failed to install SuperClaude"
  fi
else
  log_warning "pipx not found — install python-pipx first, then run: pipx install superclaude && superclaude install"
fi

# ─────────────────────────────────────────────────────────────
# 6. Fish shell config (Ryoku's default shell is fish)
# ─────────────────────────────────────────────────────────────
echo "Setting up BWO dotfiles (fish)..."
DOTFILES="$SCRIPT_DIR/dotfiles"

FISH_CONF_D="$HOME/.config/fish/conf.d"
mkdir -p "$FISH_CONF_D"

if [[ -f "$DOTFILES/fish/bwo-aliases.fish" ]]; then
  cp "$DOTFILES/fish/bwo-aliases.fish" "$FISH_CONF_D/bwo-aliases.fish"
  log_success "Fish aliases installed → ~/.config/fish/conf.d/bwo-aliases.fish"
fi

# Fish exports: PATH, editor, FZF integration
cat > "$FISH_CONF_D/bwo-exports.fish" << 'EOF'
# BWO exports for Ryoku (fish)
set -gx EDITOR nvim
set -gx VISUAL nvim
fish_add_path -g $HOME/.local/bin
fish_add_path -g ./node_modules/.bin
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --glob '!.git'"
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx NODE_OPTIONS "--max-old-space-size=8192"
EOF
log_success "Fish exports installed → ~/.config/fish/conf.d/bwo-exports.fish"

# ─────────────────────────────────────────────────────────────
# 7. Neovim config — add plugins on top of Ryoku's nvim
# ─────────────────────────────────────────────────────────────
NVIM_PLUGINS="$HOME/.config/nvim/lua/plugins"
mkdir -p "$NVIM_PLUGINS"

for lua_file in "$DOTFILES"/nvim/.config/nvim/lua/plugins/*.lua; do
  [[ -f "$lua_file" ]] || continue
  dest="$NVIM_PLUGINS/$(basename "$lua_file")"
  if [[ ! -f "$dest" ]]; then
    cp "$lua_file" "$dest"
    log_success "Neovim plugin installed: $(basename "$lua_file")"
  else
    log_info "Skipping existing nvim plugin: $(basename "$lua_file") (already exists)"
  fi
  done

# ─────────────────────────────────────────────────────────────
# 8. SuperClaude dotfiles
# ───────────────────────────────── ported from the Mac repo
# ─────────────────────────────────────────────────────────────
if [[ -d "$DOTFILES/superclaude/.claude" ]]; then
  CLAUDE_DIR="$HOME/.claude"
  mkdir -p "$CLAUDE_DIR/commands/sc"
  for f in "$DOTFILES"/superclaude/.claude/commands/sc/*.md; do
    [[ -f "$f" ]] || continue
    dest="$CLAUDE_DIR/commands/sc/$(basename "$f")"
    [[ -f "$dest" ]] || cp "$f" "$dest"
  done
  log_success "SuperClaude commands available in ~/.claude/commands/sc/"
fi

# ─────────────────────────────────────────────────────────────
# 9. Obsidian vault config (only if the vault exists — LiveSync
#    fetches the content; this restores plugin settings)
# ─────────────────────────────────────────────────────────────
OBSIDIAN_VAULT="$HOME/Documents/bwo-second-brain"
if [[ -d "$OBSIDIAN_VAULT" ]] && [[ -d "$DOTFILES/obsidian/.obsidian" ]]; then
  cp -r "$DOTFILES/obsidian/.obsidian" "$OBSIDIAN_VAULT/"
  log_success "Obsidian vault config restored"
elif [[ ! -d "$OBSIDIAN_VAULT" ]]; then
  log_warning "Obsidian vault not found at $OBSIDIAN_VAULT — skipping"
  log_info "Vault fetch via LiveSync first, then re-run this script"
fi

# ─────────────────────────────────────────────────────────────
# 10. Zed config
# ─────────────────────────────────────────────────────────────
ZED_CFG_SRC="$DOTFILES/zed/.config/zed/settings.json"
ZED_CFG_DIR="$HOME/.config/zed"
if [[ -f "$ZED_CFG_SRC" ]]; then
  mkdir -p "$ZED_CFG_DIR"
  if [[ ! -f "$ZED_CFG_DIR/settings.json" ]]; then
    cp "$ZED_CFG_SRC" "$ZED_CFG_DIR/settings.json"
    log_success "Zed config installed → ~/.config/zed/settings.json"
  else
    log_info "Skipping Zed config — ~/.config/zed/settings.json already exists"
  fi
fi

# ─────────────────────────────────────────────────────────────
# 11. Vim minimal config
# ─────────────────────────────────────────────────────────────
if [[ -f "$DOTFILES/vim/.vimrc" ]] && [[ ! -f "$HOME/.vimrc" ]]; then
  cp "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"
  log_success "Vim config installed"
fi

# ─────────────────────────────────────────────────────────────
# 12. Done
# ─────────────────────────────────────────────────────────────
echo ""
echo "✅ BWO Ryoku AutoSetup complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Restart your terminal (fish picks up conf.d on new shells)"
echo "  2. Restart Claude Code to access SuperClaude commands (type '/sc:')"
echo "  3. If new to Vim: run 'vimtutor' first, then graduate to 'nvim'"
echo "  4. Launch nvim once to let lazy.nvim install plugins"
echo "  5. ryoku doctor --check  (Ryoku's own self-check, 30 s)"
echo ""
echo "⚡ SuperClaude Framework:"
echo "  - 30+ slash commands (type '/sc:' in Claude Code)"
echo "  - Run 'superclaude --help' for CLI commands"
echo ""