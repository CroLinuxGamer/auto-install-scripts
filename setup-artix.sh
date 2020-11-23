#!/bin/sh

# this a an artix install script that helps mostly me to quickly
# setup my artix linux installations. Since I dont want to do everything
# manually every time I'm installing artix.

# nice clean screen because words are bloat ;)
clear

# check boot mode
printf "Checking your boot mode...\n\n"
if [ -d "/sys/firmware/efi/efivars" ]; then
    boot_mode="uefi" 
else
    boot_mode="bios"
fi


# Partitoning function that calls for users program of choice
partitioning()
{
    clear
    printf "Listing your partitions\n\n" # listing partitions on the installation target
    lsblk
    printf "\n\n"
    read -p "Write path of the drive you will be using for partitioning: " drive
    while true; do # checking if the drive exists
        if [ -e "$drive" ]; then
            break
        else
            echo "That path is wrong?"
            echo "Try again!"
            read -p "Write path of the drive you will be using for partitioning: " drive
        fi
    done
    while true; do # doing partitioning until you are satisfied
        printf "What program do you want to use for partitioning?\n1. fdisk\n2. cfdisk\n3. parted\n4. fdisk\n\n"
        read -p "Choose your preferred partitioning tool: " tool
        case $tool in
            [1]* ) fdisk $drive ;;
            [2]* ) cfdisk $drive ;;
            [3]* ) parted $drive ;;
            [4]* ) fdisk $drive ;;
        esac
        clear 
        printf "Listing your newly created partitions\n\n"
        lsblk
        printf "\n\n"
        read -p "Are you done with partitioning? " yn
        case $yn in
            [Yy]* ) break ;;
            [Nn]* ) ;;
            * ) echo "Please answer with Y or N" ;;
        esac
    done
}

formating()
{
    clear
    while true; do
        printf "Listing partitions...\n\n"
        lsblk
        read -p "Write your root partition path " root
       if [ -e "$root" ]; then
           break
       else
           echo "That partition doesnt exist!"
           echo "Please try again!"
           clear
       fi
    done
}

# checking if I already have partitions ready
while true; do
    read -p "Do you have ready partitions? " yn
    case $yn in
        [Yy]* ) break ;;
        [Nn]* ) partitioning; break ;;
        * ) echo "Please answer with Y or N" ;;
    esac
done

clear

# checking if there is any need for formating partitionsa
# and making swap partitions if present
while true; do
    read -p "Do you need to format any partitions? " yn
    case $yn in
        [Yy]* ) formating; break ;;
        [Nn]* ) break ;;
        * ) echo "Please answer with Y or N" ;;
    esac
done

echo "Your arch install is finished you can now reboot your pc!"
