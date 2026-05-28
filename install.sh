#!/usr/bin/env bash

# Stop script immediately if any command fails
set -e

# Paths
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_old_$(date +%Y%m%d_%H%M%S)"
CONFIG_DIR="$HOME/.config"

# Helper functions
link_config() {
    local source_path="$1"
    local target_path="$2"

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
            echo "Already linked: $target_path"
            return
        fi
        echo "Found existing configuration at $target_path"
        echo "Creating backup in $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        mv "$target_path" "$BACKUP_DIR/"
    fi
    
    # Create the symbolic link
    mkdir -p "$(dirname "$target_path")"
    ln -s "$source_path" "$target_path"
    echo "Linked: $target_path -> $source_path"
}


# Link configurations
echo "Starting Dotfiles deployment..."
echo "Repository directory: $DOTFILES_DIR"
echo
mkdir -p "$CONFIG_DIR"

link_config "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"


# Finish
echo "All done! Your configuration is linked and active."