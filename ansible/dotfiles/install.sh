#!/bin/bash
#
# install.sh — Symlink dotfiles to their expected locations.
#
# Usage:
#   ./install.sh          Full install (packages + symlinks + plugins)
#   ./install.sh --link   Symlinks only (no package install, no plugin setup)
#
# Safe to re-run: existing files are backed up to ~/.dotfiles-backup/
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
LINK_ONLY=false

if [[ "${1:-}" == "--link" ]]; then
    LINK_ONLY=true
fi

# ── helpers ──────────────────────────────────────────────────────────

backup_and_link() {
    local src="$1"
    local dst="$2"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dst")"

    # If destination exists and isn't already the right symlink, back it up
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            return 0  # already correct
        fi
        mkdir -p "$BACKUP_DIR"
        mv "$dst" "$BACKUP_DIR/" 2>/dev/null || true
        echo "  backed up: $dst → $BACKUP_DIR/"
    fi

    ln -sf "$src" "$dst"
    echo "  linked: $dst → $src"
}

# ── symlinks ─────────────────────────────────────────────────────────

echo "Linking dotfiles..."

# Fish shell
backup_and_link "$DOTFILES_DIR/config/fish/config.fish"      "$HOME/.config/fish/config.fish"
backup_and_link "$DOTFILES_DIR/config/fish/conf.d/aliases.fish"   "$HOME/.config/fish/conf.d/aliases.fish"
backup_and_link "$DOTFILES_DIR/config/fish/conf.d/envvars.fish"   "$HOME/.config/fish/conf.d/envvars.fish"
backup_and_link "$DOTFILES_DIR/config/fish/conf.d/functions.fish" "$HOME/.config/fish/conf.d/functions.fish"

# Tmux
backup_and_link "$DOTFILES_DIR/config/tmux/tmux.conf"   "$HOME/.tmux.conf"

# Neovim
backup_and_link "$DOTFILES_DIR/config/nvim/init.lua"     "$HOME/.config/nvim/init.lua"

# Kitty
backup_and_link "$DOTFILES_DIR/config/kitty/kitty.conf"  "$HOME/.config/kitty/kitty.conf"

# Git
backup_and_link "$DOTFILES_DIR/config/git/gitconfig"     "$HOME/.gitconfig"

echo "Done linking."

if [ "$LINK_ONLY" = true ]; then
    echo "Symlinks only — skipping packages and plugins."
    exit 0
fi

# ── packages ─────────────────────────────────────────────────────────

echo ""
echo "Installing packages..."
bash "$DOTFILES_DIR/install-scripts/01-install-packages.sh"

# ── plugins ──────────────────────────────────────────────────────────

if command -v fish &>/dev/null; then
    echo ""
    echo "Setting up Fish plugins..."
    fish "$DOTFILES_DIR/install-scripts/03-fisher-install.fish"
    fish "$DOTFILES_DIR/install-scripts/04-fish-plugins.fish"
    fish "$DOTFILES_DIR/install-scripts/05-tmux-plugins.fish"
    fish "$DOTFILES_DIR/install-scripts/06-vim-setup.fish"
fi

# ── final touches ────────────────────────────────────────────────────

echo ""
echo "Running final setup..."
bash "$DOTFILES_DIR/install-scripts/07-last-touches.sh"

echo ""
echo "All done. Restart your terminal or run: exec fish"
