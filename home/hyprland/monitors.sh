#!/usr/bin/env bash

monitors=$(hyprctl -j monitors | jq -r '.[].name' | sort | tr '\n' ' ')

echo "MONITORS=$monitors!"
if [ "$monitors" = "DP-2 HDMI-A-1 " ]; then
    echo "mainix detected"
    hyprctl keyword monitor "DP-2,2560x1440@144,0x0,1"
    hyprctl keyword monitor "HDMI-A-1,1920x1080@60,2560x180,1"
    hyprctl keyword workspace "1, monitor:DP-2"
    hyprctl keyword workspace "2, monitor:DP-2"
    hyprctl keyword workspace "3, monitor:DP-2"
    hyprctl keyword workspace "4, monitor:DP-2"
    hyprctl keyword workspace "5, monitor:DP-2"
    hyprctl keyword workspace "6, monitor:DP-2"
    hyprctl keyword workspace "7, monitor:DP-2"
    hyprctl keyword workspace "8, monitor:HDMI-A-1"
    hyprctl keyword workspace "9, monitor:HDMI-A-1"
    hyprctl keyword workspace "10, monitor:HDMI-A-1"
    hyprctl keyword input:sensitivity -1.0
else
    hyprctl keyword monitor " ,preferred,auto,1"
fi
