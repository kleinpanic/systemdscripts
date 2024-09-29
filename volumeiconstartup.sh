#!/usr/bin/env bash

check_x_server() {
    if xset q > /dev/null 2>&1; then
        echo "X server is running."
        return 0
    else 
        echo "X server is not running"
        return 1
    fi
}

until check_x_server; do
    sleep 1
done

while true; do 
    if ! pgrep -x "volumeicon" > /dev/null; then
        echo "starting volumeicon"
        DISPLAY=:0 volumeicon  
    else
        echo "volumeicon is active already"
    fi
    sleep 5 
done
