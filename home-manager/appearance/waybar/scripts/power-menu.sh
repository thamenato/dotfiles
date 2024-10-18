#!/usr/bin/env bash

entries="Logout\nSuspend\nReboot\nShutdown"

selected=$(echo -e $entries | rofi -dmenu | awk '{print tolower($1)}')

case $selected in
  logout)
    swaymsg exit;;
  suspend)
    exec systemctl suspend;;
  reboot)
    exec systemctl reboot;;
  shutdown)
    exec systemctl poweroff -i;;
esac
