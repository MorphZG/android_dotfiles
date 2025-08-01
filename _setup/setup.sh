#!/bin/bash
# Setup script for android termux encironment
# Avoid interactive commands that require user input
# Read the manuals to set non-interactive options

# Exit immediately if a command exits with a non-zero status.
set -e

GIT_CLONES="$HOME/git_clones"
mkdir -p "$GIT_CLONES"

# --- Package Installations ---
echo "Installing base packages..."
pkg update
pkg install -y git zsh curl wget tmux ranger nodejs openssh stow

# Install Oh My Zsh (this will also set zsh as the default shell)
# The installer script handles the chsh part.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi


# --- Tool Installations ---
echo "Installing additional tools..."

# Install Neovim and Kickstart.nvim configuration
if [ ! -d "$HOME/.config/nvim" ]; then
    echo "Cloning Kickstart.nvim..."
    # Note: This assumes you have synced your fork.
    git clone https://github.com/MorphZG/kickstart.nvim.git "$HOME/.config/nvim"
    echo "Run nvim and :checkhealth to complete Neovim setup."
else
    echo "Neovim config already exists."
fi

# Install fzf (non-interactive)
if [ ! -d "$HOME/.fzf" ]; then
    echo "Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all
else
    echo "fzf is already installed."
fi

# --- Dotfiles Installation ---
# ! Keep this at the bottom
# Customized config files should install after everything else.
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Cloning and installing dotfiles..."
    git clone --recurse-submodules https://github.com/morphzg/android_dotfiles.git "$HOME/.dotfiles"
    #"$HOME/.dotfiles/install"
else
    echo "Dotfiles repository already exists."
fi

echo "Setup complete!"
