#!/bin/sh

system_clock()
{
    ls /usr/share/zoneinfo
    while true; do
        read -p "Chose your zone: " zone
        if [ -f "/usr/share/zoneinfo/$zone" ]; then
            ln -sf /usr/share/zoneinfo/"$zone" /etc/localtime
            break
        else 
            echo "That zone doesn't exist!"
            echo "Please enter a valid zone"
        fi
    done         
}

# settings up system clock
clear
echo "Setting up system clock..."
system_clock

# setting hardware clock
clear
echo "Setting up hardware clock..."
hwclock --systohc 
sleep 2

# installing nano
clear
echo "Installing nano..."
pacman -S nano

# locale settings
clear 
echo "Now you will need to uncomment the locale's you desire in the next file"
sleep 5
nano /etc/locale.gen

# generating locale's
clear
locale-gen

# setting languange in locale.conf
echo "Now you need to set the locale variable in locale.conf"
sleep 5
nano /etc/locale.conf
