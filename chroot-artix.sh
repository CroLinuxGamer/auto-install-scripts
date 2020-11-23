#!/bin/sh

system_clock()
{
    ls /usr/share/zoneinfo
    while true; do
        read -p "Chose your zone: " zone
        if [ -d "/usr/share/zoneinfo/$zone" ]; then
            break
        else 
            echo "That zone doesn't exist!"
            echo "Please enter a valid zone"
        fi
        while true; do
            read -p "Choose your city: " city
            if [ -d "/usr/share/zoneinfo/$zone/$city" ]; then
                ln -sf /usr/share/zoneinfo/$zone/$city /etc/localtime
                break
            else
                echo "That city doesn't exist!"
                echo "Please enter a valid city"
            fi
        done
    done         
}

# settings up system clock
echo "Setting up system clock..."
system_clock
