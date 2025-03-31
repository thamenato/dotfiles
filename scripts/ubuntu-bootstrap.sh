#!/usr/bin/env bash

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install -y \
    curl \
    git \
    xdg-desktop-portal-wlr

# Install nix
curl --proto '=https' --tlsv1.2 -sSf \
    -L https://install.determinate.systems/nix | sh -s -- install

# Permanently disable AppArmor restrictions
echo 'kernel.apparmor_restrict_unprivileged_userns = 0' |
    sudo tee /etc/sysctl.d/20-apparmor-donotrestrict.conf

# Install drivers
sudo ubuntu-drivers install

# Install tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# Configure sway entry
echo """[Desktop Entry]
Name=Sway
Comment=An i3-compatible Wayland compositor
Exec=$(which sway)
Type=Application
DesktopNames=sway;wlroots
""" | sudo tee /usr/share/wayland-sessions/sway.desktop
