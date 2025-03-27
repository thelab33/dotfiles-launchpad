#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# ──────────────────────────────────────────────────────────────
# 🧙 SETUP SCRIPT — dotfiles-launchpad bootstrapper
# Author: thelab33
# Repo: https://github.com/thelab33/dotfiles-launchpad
# ──────────────────────────────────────────────────────────────

REPO_URL="https://github.com/thelab33/dotfiles-launchpad.git"
DOTFILES_DIR="$HOME/dotfiles_launchpad"
BIN_DIR="$HOME/bin"

echo -e "\n📦 Checking dotfiles repo location..."

if [ -d "$DOTFILES_DIR" ]; then
  echo "📁 $DOTFILES_DIR already exists. Skipping clone."
else
  echo "🔄 Cloning dotfiles from $REPO_URL..."
  git clone "$REPO_URL" "$DOTFILES_DIR"
fi

echo -e "\n📂 Setting up files..."

# Backup old zshrc
if [ -f "$HOME/.zshrc" ]; then
  BACKUP="$HOME/.zshrc.backup.$(date +%s)"
  echo "🗄 Backing up existing .zshrc to $BACKUP"
  mv "$HOME/.zshrc" "$BACKUP"
fi

echo "🔗 Installing new .zshrc and launchpad..."
cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

mkdir -p "$BIN_DIR"
cp "$DOTFILES_DIR/launchpad" "$BIN_DIR/launchpad"
chmod +x "$BIN_DIR/launchpad"

# Add to PATH if not already
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo "➕ Adding $BIN_DIR to PATH in .zshrc"
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.zshrc"
fi

# Install zip/unzip if missing
if ! command -v zip &> /dev/null; then
  echo -e "\n📦 Installing zip and unzip..."
  sudo apt update && sudo apt install zip unzip -y
fi

# Set git user info if missing
if ! git config --global user.name &>/dev/null; then
  read -rp "🧑 Enter your Git username: " git_user
  git config --global user.name "$git_user"
fi

if ! git config --global user.email &>/dev/null; then
  read -rp "📧 Enter your Git email: " git_email
  git config --global user.email "$git_email"
fi

echo -e "\n✅ Setup complete! Dotfiles and launchpad installed."

# Launch the shell anew
echo "🚀 Starting a fresh Zsh shell..."
exec zsh
