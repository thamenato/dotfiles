#!/usr/bin/env bash

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-get install -y \
    curl \
    git \
    xdg-desktop-portal-wlr \
    sway

# Install lix (nix)
curl -sSf -L https://install.lix.systems/lix | sh -s -- install

# Permanently disable AppArmor restrictions
echo 'kernel.apparmor_restrict_unprivileged_userns = 0' |
    sudo tee /etc/sysctl.d/20-apparmor-donotrestrict.conf

# Install drivers
sudo ubuntu-drivers install

# Install tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# Configure niri files (due to home-manager only supporting the package itself)
sudo ln -s "$(which niri)" /usr/bin/niri
sudo ln -s "$(which niri-session)" /usr/bin/niri-session
# gdm/wayland
curl https://raw.githubusercontent.com/YaLTeR/niri/refs/heads/main/resources/niri.desktop -o niri.desktop
sudo mv niri.desktop /usr/local/share/wayland-sessions/niri.desktop
curl https://raw.githubusercontent.com/YaLTeR/niri/refs/heads/main/resources/niri-portals.conf -o niri-portals.conf
sudo mv niri-portals.conf /usr/loca/share/xdg-desktop-portal/niri-portals.conf
# systemd config
curl https://raw.githubusercontent.com/YaLTeR/niri/refs/heads/main/resources/niri.service -o niri.service
sudo mv niri.service /etc/systemd/user/niri.service
curl https://raw.githubusercontent.com/YaLTeR/niri/refs/heads/main/resources/niri-shutdown.target -o niri-shutdown.target
sudo mv niri-shutdown.target /etc/systemd/user/niri-shutdown.target
