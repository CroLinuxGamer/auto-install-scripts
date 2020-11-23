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

# formating the home partition
home_format()
{
    while true; do
        read -p "Write the path to your home partitiom " home
        if [ -e "$home" ]; then
            mkfs.ext4 -L HOME $home
            break
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
        fi
    done
}

# formating the 
boot_format()
{
    while true; do
        read -p "Write the path to your boot partitiom " boot
        if [ -e "$boot" ]; then
            if [ $boot_mode = "bios" ]; then # checking the boot mode
                mkfs.ext4 -L BOOT $boot
                break
            else 
                 mkfs.fat -F 32 $boo
                 break
            fi
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
        fi
    done
}

# making swap format
swap_format()
{
    while true; do
        read -p "Write the path to swap partitiom " swap
        if [ -e "$swap" ]; then
            mkswap -L SWAP $swap
            break
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
        fi
    done
}

# the main formating function
formating()
{
    clear
    printf "Listing partitions...\n\n"
    lsblk
    read -p "Write your root partition path " root
    while true; do
        if [ -e "$root" ]; then
            mkfs.ext4 -L ROOT $root
            break
        else
            echo "That partition doesnt exist!"
            echo "Please try again!"
        read -p "Write your root partition path " root
        fi
    done
    while true; do
        read -p "Do you have a separate home partition? " yn
        case $yn in
            [Yy]* ) home_format; break ;;
            [Nn]* ) break ;;
            * ) echo "Please answer with Y or N" ;;
        esac
    done
    while true; do
        read -p "Do you have a separate boot partition? " yn
        case $yn in
            [Yy]* ) boot_format; break ;;
            [Nn]* ) break ;;
            * ) echo "Please answer with Y or N" ;;
        esac
    done
    while true; do
        read -p "Do you have a swap partition? " yn
        case $yn in
            [Yy]* ) swap_format;break ;;
            [Nn]* ) break ;;
            * ) echo "Please answer with Y or N" ;;
        esac
    done
}

mount_home()
{
    while true; do
        read -p "Write the path to your root partition " home
        if [ -e "$home" ]; then
            mkdir /mnt/home
            mount $home /mnt/home
            break
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
        fi
    done
}

mount_boot()
{
    while true; do
        read -p "Write the path to your root partition " boot
        if [ -e "$boot" ]; then
            mkdir /mnt/boot
            mount $boot /mnt/boot
            break
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
        fi
    done
}

mount_swap()
{
    while true; do
        read -p "Write the path to your swap partition " swap
        if [ -e "$swap" ]; then
            swapon $swap
            break
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
        fi
    done
}

mounting()
{
    while true; do
        read -p "Write the path to your root partition " root
        if [ -e "$root" ]; then
            mount $root /mnt
            break
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
        fi
    done
    while true; do
        read -p "Do you have a home partition? " yn
        case $yn in
            [Yy]* ) mount_home;break ;;
            [Nn]* ) break ;;
            * ) echo "Please answer with Y or N" ;;
        esac
    done
        while true; do
        read -p "Do you have a boot partition? " yn
        case $yn in
            [Yy]* ) mount_boot;break ;;
            [Nn]* ) break ;;
            * ) echo "Please answer with Y or N" ;;
        esac
    done
        while true; do
        read -p "Do you have a swap partition? " yn
        case $yn in
            [Yy]* ) mount_swap;break ;;
            [Nn]* ) break ;;
            * ) echo "Please answer with Y or N" ;;
        esac
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

# mounting partitions
clear
print "Mounting partitions..."
mounting

clear

echo "Your arch install is finished you can now reboot your pc!"
