#!/bin/bash

# Inspired by https://github.com/bahamas10/dotfiles/blob/master/install

# Define variables
REPO_PATH="$(pwd)"  # Get the current directory where the script is located
NVIM_CONFIG_DIR="$HOME/.config/nvim"
INIT_VIM_SOURCE="$REPO_PATH/init.vim"
INIT_VIM_DEST="$NVIM_CONFIG_DIR/init.vim"


# Create the Neovim config directory if it doesn't exist
mkdir -p "$NVIM_CONFIG_DIR"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color


symlink() {
  printf '%55s -> %s\n' "${1/#$HOME/\~}" "${2/#$HOME/\~}"
	ln -nsf "$@"
}
configfiles=(
  skhd
  yabai
)

# setup .zshrc
if [ -e ~/.zshrc ]; then
  echo -e "${YELLOW}Removing existing .zshrc...${NC}"
  rm ~/.zshrc
fi

echo -e "${GREEN}Creating symbolic link for .zshrc...${NC}"
ln -s "$PWD/zshrc" ~/.zshrc

# Create a symbolic link for init.vim
if [ -e "$INIT_VIM_DEST" ]; then
  echo -e "${YELLOW}Removing existing init.vim...${NC}"
  rm "$INIT_VIM_DEST"
fi

echo -e "${GREEN}Creating symbolic link for init.vim...${NC}"


# loop through config files in ~/.config/${configDirectory}/${configFile}
for f in "${configfiles[@]}"; do
  if [[ -d ~/.config/$f && ! -L ~/.config/$f ]]; then
    printf  "${YELLOW} Removing existing directory ~/.config/$f...\n${NC}"
    rm -r ~/.config/"$f"
  fi
	symlink "$PWD/$f" ~/.config/"$f"
done

ln -s "$INIT_VIM_SOURCE" "$INIT_VIM_DEST"

if command -v brew &> /dev/null; then
  echo -e "${GREEN}Homebrew is installed. Checking for Hack Nerd Font...${NC}"

  if brew list --cask | grep -q "font-hack-nerd-font"; then
    echo -e "${GREEN}Hack Nerd Font is already installed.${NC}"
  else
    echo -e "${YELLOW}Hack Nerd Font is not installed. Installing...${NC}"
    brew tap homebrew/cask-fonts
    brew install font-hack-nerd-font
  fi
else
  echo -r "${RED}Homebrew is not installed. Please install it and run the script again${NC}"
  return 1
fi
# Check if Neovim is installed
if command -v nvim &> /dev/null
then
  echo -e "${GREEN}Neovim is already installed.${NC}"
else
  echo -e "${YELLOW}Neovim is not installed. Installing Neovim...${NC}"
  # For Debian-based systems
  brew install neovim

  # For other systems, you may need different installation commands
fi

# Ensure required packages like ripgrep are installed
# This script uses `apt` for installation. Modify as needed for other package managers.
echo -e "${YELLOW}Checking for required packages...${NC}"
if brew list ripgrep &> /dev/null; then
  echo -e "${GREEN}ripgrep is already installed.${NC}"
else
  echo -e "${YELLOW}ripgrep is not installed. Installing ripgrep...${NC}"
  brew install ripgrep
fi
echo -e "${GREEN}Setup complete.${NC}"
