#!/bin/sh

# this a an artix install script that helps mostly me to quickly
# setup my artix linux installations. Since I dont want to do everything
# manually every time I'm installing artix.

# nice clean screen because words are bloat ;)

clear

COLUMNS=$(tput cols)
title="[Auto Arch]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"

# check boot mode
printf "Checking your boot mode...\n\n"
if [ -d "/sys/firmware/efi/efivars" ]; then
    boot_mode="uefi" 
else
    boot_mode="bios"
fi
sleep 2


# Partitoning function that calls for users program of choice
partitioning()
{
    clear
    COLUMNS=$(tput cols)
    title="[Partitioning]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    printf "Listing your partitions...\n\n" # listing partitions on the installation target
    lsblk
    printf "\n\n"
    read -p "Write path of the drive you will be using for partitioning: " drive
    while true; do # checking if the drive exists
        clear
        if [ -e "$drive" ]; then # if drive exists
            break # continue
        else
            echo "That path is wrong?"
            echo "Try again!"
            read -p "Write path of the drive you will be using for partitioning: " drive
        fi
    done
    while true; do # doing partitioning until you are satisfied
        printf "What tool do you want to use for partitioning?\n1. fdisk\n2. cfdisk\n3. parted\n4. fdisk\n\n" # listing partitioning tools
        read -p "Choose your preferred partitioning tool: " tool
        case $tool in
            [1]* ) fdisk $drive ;;
            [2]* ) cfdisk $drive ;;
            [3]* ) parted $drive ;;
            [4]* ) fdisk $drive ;;
        esac
        clear 
        printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
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
    clear
    COLUMNS=$(tput cols)
    title="[Formating]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    lsblk
    printf "\n\nFormating your home partition...\n\n"
    while true; do
        read -p "Write the path to your home partitiom: " home
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
    clear
    COLUMNS=$(tput cols)
    title="[Formating]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    lsblk
    printf "\n\nFormating your boot partitiom...\n\n"
    while true; do
        read -p "Write the path to your boot partitiom: " boot
        if [ -e "$boot" ]; then
            if [ $boot_mode = "bios" ]; then # checking the boot mode
                mkfs.ext4 -L BOOT $boot
                break
            else 
                 mkfs.fat -F 32 $boot
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
    clear
    COLUMNS=$(tput cols)
    title="[Formating]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    lsblk
    printf "\n\nFormating your swap partition...\n\n"
    while true; do
        read -p "Write the path to swap partitiom: " swap
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
    COLUMNS=$(tput cols)
    title="[Formating]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    printf "Listing partitions...\n\n"
    lsblk
    read -p "Write your root partition path: " root
    while true; do
        if [ -e "$root" ]; then
            mkfs.ext4 -L ROOT $root
            break
        else
            echo "That partition doesnt exist!"
            echo "Please try again!"
        read -p "Write your root partition path: " root
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
    clear
    COLUMNS=$(tput cols)
    title="[Mounting]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    printf "Listing your partitions..."
    lsblk
    while true; do
        read -p "Write the path to your home partition: " home
        if [ -e "$home" ]; then
            echo "Mounting home partition..."
            mkdir /mnt/home
            mount $home /mnt/home
            sleep 2
            break
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
        fi
    done
}

mount_boot()
{
    clear
    COLUMNS=$(tput cols)
    title="[Mounting]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    printf "Listing your partitions..."
    lsblk
    while true; do
        read -p "Write the path to your boot partition: " boot
        if [ -e "$boot" ]; then
            echo "Mounting boot partition..."
            mkdir /mnt/boot
            mount $boot /mnt/boot
            sleep 2
            break
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
        fi
    done
}

mount_swap()
{
    clear
    COLUMNS=$(tput cols)
    title="[Mounting]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    printf "Listing your partitions..."
    lsblk
    while true; do
        read -p "Write the path to your swap partition: " swap
        if [ -e "$swap" ]; then
            echo "Mounting swap partition..."
            swapon $swap
            sleep 2
            break
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
        fi
    done
}

mounting()
{
    clear
    COLUMNS=$(tput cols)
    title="[Mounting]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    printf "Listing your partitions..."
    lsblk
    while true; do
        read -p "Write the path to your root partition: " root
        if [ -e "$root" ]; then
            echo "Mounting root partition..."
            sleep 2
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

kernel_install()
{
    clear
    COLUMNS=$(tput cols)
    title="[Kernel installation]"
    printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
    printf "Choose your desired kernel\n1. linux\n2. linux-lts\n3. linux-zen\n"
    while true; do
        read -p "Type the nubmer of your desired kernel: " kernel
        case $kernel in
            [1]* ) pacstrap /mnt linux linux-firmware; break ;;
            [2]* ) pacstrap /mnt linux-lts linux-firmware; break ;;
            [3]* ) pacstrap /mnt linux-zen linux-firmware; break ;;
            * ) echo "Please answer with the number before the name of the kernel!"
        esac
    done
}
unmount_swap()
{
    while true; do
        read -p "Write the path to your swap partition: " swap
        if [ -e "$swap" ]; then
            echo "Turning off swap ..."
            swapoff $swap
            sleep 2
            break
        else
            echo "That partitiom doesn't exist!"
            echo "Please try again!"
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

# checking if there is any need for formating partitionsa
# and making swap partitions if present
clear
COLUMNS=$(tput cols)
title="[Auto Arch"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
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
COLUMNS=$(tput cols)
title="[Auto Arch]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "Mounting partitions...\n"
sleep 2
mounting

# installing base system
clear
COLUMNS=$(tput cols)
title="[Auto Arch]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "Installing base system...\n"
sleep 2
pacstrap /mnt base base-devel

# installing kernel
clear
COLUMNS=$(tput cols)
title="[Auto Arch]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "Installing kernel...\n"
sleep 2
kernel_install

# generating fstab
clear
COLUMNS=$(tput cols)
title="[Auto Arch]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "Generating fstab...\n"
fstabgen -U /mnt >> /mnt/etc/fstab
sleep 2

clear
COLUMNS=$(tput cols)
title="[Auto Arch]"
printf "%*s\n\n" $(((${#title}+$COLUMNS)/2)) "$title"
printf "Downloading the chroot part of the script..."
arch-chroot /mnt curl -sO https://raw.githubusercontent.com/CroLinuxGamer/auto-install-scripts/main/chroot-arch.sh
arch-chroot /mnt chmod +x chroot-arch.sh
sleep 2
arch-chroot /mnt ./chroot-arch.sh
arch-chroot /mnt rm -f chroot-arch.sh

# unmount drives and turning off swap
print "Unmounting drives..."
umount -R /mnt
lsblk
while true; do
    read -p "Did you enable swap? " yn
    case $yn in
        [Yy]* ) unmount_swap; break ;;
        [Nn]* ) break ;;
        * ) echo "Please answer with Y or N" ;;
    esac
done

clear

echo "Your arch install is finished you can now reboot your pc!"
