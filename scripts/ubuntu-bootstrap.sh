#!/usr/bin/env bash

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install curl git -y

# Install nix
curl --proto '=https' --tlsv1.2 -sSf \
    -L https://install.determinate.systems/nix | sh -s -- install

# Permanently disable AppArmor restrictions
echo 'kernel.apparmor_restrict_unprivileged_userns = 0' |
    sudo tee /etc/sysctl.d/20-apparmor-donotrestrict.conf

# Install drivers
sudo ubuntu-drivers install

echo """[Desktop Entry]
Name=Sway
Comment=An i3-compatible Wayland compositor
Exec=$(which sway)
Type=Application
DesktopNames=sway;wlroots
""" | sudo tee /usr/share/wayland-sessions/sway.desktop
