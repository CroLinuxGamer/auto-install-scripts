#!/bin/sh


# Partitoning function that calls for users program of choice
partitioning()
{
    clear
    printf "Listing your partitions\n\n"
    lsblk
    printf "\n\n"
    read -p "Write path of the drive you will be using for partitioning: " drive
    while true; do
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

# check boot mode
echo "Checking your boot mode..."
if [ -d "/sys/firmware/efi/efivars" ]; then
    boot_mode="uefi" 
else
    boot_mode="bios"
fi
sleep 2

clear

while true; do
    read -p "Do you have ready partitions? y/n" yn
    case $yn in
        [Yy]* ) break ;;
        [Nn]* ) partitioning; break ;;
        * ) echo "Please answer with Y or N" ;;
    esac
done

clear

echo "You arch install is finished you can now reboot your pc!"
