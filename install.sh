#!/bin/bash

# Define variables
REPO_PATH="$(pwd)"  # Get the current directory where the script is located
NVIM_CONFIG_DIR="$HOME/.config/nvim"
INIT_VIM_SOURCE="$REPO_PATH/init.vim"
INIT_VIM_DEST="$NVIM_CONFIG_DIR/init.vim"

# Create the Neovim config directory if it doesn't exist
mkdir -p "$NVIM_CONFIG_DIR"

# Create a symbolic link for init.vim
if [ -e "$INIT_VIM_DEST" ]; then
  echo "Removing existing init.vim..."
  rm "$INIT_VIM_DEST"
fi

echo "Creating symbolic link for init.vim..."
ln -s "$INIT_VIM_SOURCE" "$INIT_VIM_DEST"

if command -v brew &> /dev/null; then
  echo "Homebrew is installed. Checking for Hack Nerd Font..."

  if brew list --cask | grep -q "font-hack-nerd-font"; then
    echo "Hack Nerd Font is already installed."
  else
    echo "Hack Nerd Font is not installed. Installing..."
    brew tap homebrew/cask-fonts
    brew install font-hack-nerd-font
  fi
else
  echo "Homebrew is not installed. Please install it and run the script again"
  return 1
fi
# Check if Neovim is installed
if command -v nvim &> /dev/null
then
  echo "Neovim is already installed."
else
  echo "Neovim is not installed. Installing Neovim..."
  # For Debian-based systems
  brew install neovim

  # For other systems, you may need different installation commands
fi

# Ensure required packages like ripgrep are installed
# This script uses `apt` for installation. Modify as needed for other package managers.
echo "Checking for required packages..."
if brew list ripgrep &> /dev/null; then
  echo "ripgrep is already installed."
else
  echo "ripgrep is not installed. Installing ripgrep..."
  brew install ripgrep
fi
echo "Setup complete."
