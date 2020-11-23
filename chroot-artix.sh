#!/bin/sh

# check boot mode
printf "Checking your boot mode...\n\n"
if [ -d "/sys/firmware/efi/efivars" ]; then
    boot_mode="uefi" 
else
    boot_mode="bios"
fi

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

grub_install()
{
    clear
    echo "Installing grub..."
    if [ $boot_mode = "bios" ]; then
        pacman -S grub
    else
        pacman -S grub efibootmgr
    fi
    while true; do
        read -p "Are you dualbooting with more operating systems?" yn
        case $yn in
            [Yy]* ) pacman -S os-prober; break ;;
            [Nn]* ) break ;;
            * ) echo "Please answer with Y or N" ;;
        esac
    done
    echo "listing your partitions"
    lsblk
    while true; do
        read -p "Write the path to your boot partitiom " boot
        if [ -e "$boot" ]; then
            if [ $boot_mode = "bios"]; then
                grub-install --recheck $boot
                break
            else
                grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=artix
                break
            fi
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
        fi
    done
    echo "Generating grub config..."
    grub-mkconfig -o /boot/grub/grub.cfg
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
clear
echo "Now you need to set the locale variable in locale.conf"
sleep 5
nano /etc/locale.conf

# setting up tty locale
clear
echo "Now you will set tty locale if you changed it in the artix install"
sleep 5
nano /etc/vconsole.conf

# grub installation
grub_install
