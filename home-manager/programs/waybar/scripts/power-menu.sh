#!/usr/bin/env bash

entries="Logout\nSuspend\nReboot\nShutdown"

selected=$(echo -e $entries | rofi -dmenu | awk '{print tolower($1)}')

case $selected in
logout)
  case $XDG_CURRENT_DESKTOP in
  sway)
    swaymsg exit
    ;;
  niri)
    niri msg action quit
    ;;
  esac
  ;;
suspend)
  exec systemctl suspend
  ;;
reboot)
  exec systemctl reboot
  ;;
shutdown)
  exec systemctl poweroff -i
  ;;
esac
