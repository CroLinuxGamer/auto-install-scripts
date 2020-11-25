#!/bin/sh

# setup lf git
clear
echo "Installing lf file manager..."
sleep 2
yay -S lf-git

# download previe needed files
clear
echo "Downloading preview needed programs..."
yay -S mediainfo glow-bin python-pdftotext epub2txt zip tar unrar 7z w3m highlight atool

# download custom config
clear
echo "Downloading custom config..."
mkdir ~/.config
mkdir ~/.config/lf
sleep 2
wget https://raw.githubusercontent.com/CroLinuxGamer/Dotfiles/master/.config/lf/lfrc -O .config/lf/lfrc

# downloading custom preview script
clear
mkdir ~/.local
mkdir ~/.local/bin/
echo "Downloading custom preview script..."
sleep 2
echo " Add .local/bin/ to path"
sleep 1
wget https://raw.githubusercontent.com/CroLinuxGamer/Dotfiles/master/Bin/lf/preview -O $HOME/.local/bin/preview
chmod +x ~/.local/bin/preview

# logout and login
clear
echo "Logout and then login to allow bash to load preview script into path"
