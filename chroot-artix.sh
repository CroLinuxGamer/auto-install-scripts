#!/bin/sh

# check boot mode
printf "Checking your boot mode...\n\n"
if [ -d "/sys/firmware/efi/efivars" ]; then
    boot_mode="uefi" 
else
    boot_mode="bios"
fi

COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"

system_clock()
{
    clear
    COLUMNS=$(tput cols)
    title="[System Clock]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
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
    COLUMNS=$(tput cols)
    title="[Grub install]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    echo "Installing grub..."
    if [ $boot_mode = "bios" ]; then
        pacman -S grub -y
    else
        pacman -S grub efibootmgr -y
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
        read -p "Write the path to your disk " disk
        if [ -e "$disk" ]; then
            if [ $boot_mode = "bios" ]; then
                grub-install --recheck $disk
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

network_manager()
{
    clear
    COLUMNS=$(tput cols)
    title="[Network Manager]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    printf "Choose your init system\n1. openrc\n2. runit\n3. s6\n"
    while true; do
        read -p "Type the number of the desired init system: " init
        case $init in
            [1]* ) pacman -S networkmanager-openrc -y ;  rc-update add networkmanagerd ; break ;;
            [2]* ) pacman -S networkmanager-runit -y ; printf "After rebooting you need to run \nln -s /etc/runit/sv/networkmanagerd /etc/runit/runsvdir/defaul\nto be able to use metwork manager" ; sleep 5;break ;;
            [2]* ) pacman -S networkmanager-s6 -y ; printf "After rebooting you need to run\ns6-rc-bundle -c /etc/s6/rc/compiled add default connmand\n to be able to use network manager"; sleep 5;break ;;
            * ) echo "Please answer with the nubmer before the name of the init system!" ;;
        esac
    done
}

# settings up system clock
clear
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo "Setting up system clock..."
system_clock

# setting hardware clock
clear
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo "Setting up hardware clock..."
hwclock --systohc 
sleep 2

# installing nano
clear
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo "Installing nano..."
pacman -S nano

# locale settings
clear 
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo "Now you will need to uncomment the locale's you desire in the next file"
sleep 5
nano /etc/locale.gen

# generating locale's
clear
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
locale-gen

# setting languange in locale.conf
clear
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo "Now you need to set the locale variable in locale.conf"
sleep 5
nano /etc/locale.conf

# setting up tty locale
clear
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo "Now you will set tty locale if you changed it in the artix install"
sleep 5
nano /etc/vconsole.conf

# grub installation
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
grub_install

# settins root password
clear
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo "Setting root password"
passwd

# setting user password
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
read -p "Type in your user name: " user
useradd -m $user
passwd $user

# adding user to basic groups
usermod -aG games $user
usermod -aG wheel $user
usermod -aG tty $user
usermod -aG audio $user
usermod -aG input $user
usermod -aG video $user

# set your hostname
clear
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo "Set your hostname in the next file"
sleep 5
nano /etc/hostname

# set your hosts
clear
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo "Set your hosts in the next file"
sleep 5
nano /etc/hosts

# enable wheel group to use sudo
clear 
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo "enable wheel group in the next file to be able to use sudo"
sleep 5
visudo
clear

# installing network manager
clear 
COLUMNS=$(tput cols)
title="[Chroot Artix]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
network_manager

