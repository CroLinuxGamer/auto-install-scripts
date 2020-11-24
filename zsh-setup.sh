#!/bin/sh

# make directory
mkdir .config
mkdir .config/zsh

# downloading zsh configs
echo "Downloading zsh configs..."
wget https://raw.githubusercontent.com/CroLinuxGamer/Dotfiles/master/.zshenv -O .zshenv
wget https://raw.githubusercontent.com/CroLinuxGamer/Dotfiles/master/.config/zsh/.zprofile -O .config/zsh/.zprofile
wget https://raw.githubusercontent.com/CroLinuxGamer/Dotfiles/master/.config/zsh/aliasrc -O .config/zsh/aliasrc
wget https://raw.githubusercontent.com/CroLinuxGamer/Dotfiles/master/.config/zsh/.zshrc -O .config/zsh/.zshrc

# downloading needed packages
echo "Downloading needed packages..."
yay -S zsh zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting zsh-theme-powerlevel10k

# changing user shell
echo "Changing user shell to zsh..."
chsh -s $(which zsh)

# log out
echo "Log out to load changes..."
