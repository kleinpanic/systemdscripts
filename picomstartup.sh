#!/bin/sh

check_x_server() {
    if xset q > /dev/null 2>&1; then
        echo "X server is running. Turning on picom"
        return 0
    else 
        echo "X Server is not running. Waiting."
        return 1
    fi
}

until check_x_server; do
    sleep 1
done

DISPLAY=:0 picom --config ~/.config/picom/picom.conf
