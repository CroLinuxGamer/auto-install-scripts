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
echo "Setting up system clock..."
system_clock
