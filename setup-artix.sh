#!/bin/sh

# check boot mode
if [ -d "/sys/firmware/efi/efivars" ]; then
    boot_mode="uefi" 
else
    boot_mode="bios"
fi

