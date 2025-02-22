#!/bin/bash
# Check if USB device is connected
export DISPLAY=:0
export XAUTHORITY=/home/jedi/.Xauthority
usb_connected=$(lsusb | grep -q "1a86:e5e3" && echo "yes" || echo "no")

if [ "$usb_connected" = "yes" ]; then
    # Run your command
    killall dekstop-screen & >> /hi 2>&1
    #id >> /hi
    
    #printenv >> /hi
    echo >> /hi
    USER_ID=$(sudo -u jedi id -u)
    XAUTH_PATH=$(sudo find /run/user/$USER_ID -name "xauth*")
    sleep 2
    sudo -u jedi DISPLAY=:0 XAUTHORITY=$XAUTH_PATH dekstop-screen & > /hello 2>&1
fi
