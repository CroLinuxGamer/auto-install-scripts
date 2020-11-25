#!/bin/sh

# installing newsboat
echo "Installing newsboat..."
yay -S newsboat

# downloading configs and cache
mkdir ~/.newsboat
wget https://raw.githubusercontent.com/CroLinuxGamer/Dotfiles/master/.newsboat/config -O ~/.newsboat/config
wget "https://github.com/CroLinuxGamer/Dotfiles/blob/master/.newsboat/cache.db?raw=true" -O ~/.newsboat/cache.db
wget https://raw.githubusercontent.com/CroLinuxGamer/Dotfiles/master/.newsboat/urls -O ~/.newsboat/urls
