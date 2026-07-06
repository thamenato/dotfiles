#!/usr/bin/env zsh
set -euo pipefail

# --- functions ---

apt_setup() {
    echo ">>> apt: update & install base packages"
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y \
        curl \
        git \
        xdg-desktop-portal-wlr \
        sway
}

nix_install() {
    echo ">>> nix: install lix"
    curl -sSf -L https://install.lix.systems/lix | sh -s -- install
}

apparmor_setup() {
    echo ">>> apparmor: disable unprivileged userns restrictions"
    echo 'kernel.apparmor_restrict_unprivileged_userns = 0' |
        sudo tee /etc/sysctl.d/20-apparmor-donotrestrict.conf
}

drivers_install() {
    echo ">>> drivers: install ubuntu-drivers"
    sudo ubuntu-drivers install
}

tailscale_install() {
    echo ">>> tailscale: add repo and install"
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg |
        sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list |
        sudo tee /etc/apt/sources.list.d/tailscale.list
}

gdm_setup() {
    echo ">>> gdm: use Ubuntu's default GNOME display manager"
    # We use stock gdm3 (Ubuntu default). gdm is the display manager here;
    # the wayland-sessions greeter lets us pick the niri session at login.
    # An Ubuntu update can wipe the /etc/systemd/system/display-manager.service
    # alias symlink, leaving the machine with no display manager -- so we set it
    # explicitly here rather than relying on the package to have done it.
    echo '/usr/sbin/gdm3' | sudo tee /etc/X11/default-display-manager
    sudo ln -sf /usr/lib/systemd/system/gdm.service \
        /etc/systemd/system/display-manager.service
    sudo systemctl daemon-reload
}

niri_setup() {
    echo ">>> niri: symlinks, wayland session, and systemd units"
    sudo ln -sf "$(which niri)" /usr/bin/niri
    sudo ln -sf "$(which niri-session)" /usr/bin/niri-session

    curl https://raw.githubusercontent.com/YaLTeR/niri/refs/heads/main/resources/niri.desktop -o niri.desktop
    sudo mkdir -p /usr/share/wayland-sessions
    sudo mv niri.desktop /usr/share/wayland-sessions/niri.desktop

    curl https://raw.githubusercontent.com/YaLTeR/niri/refs/heads/main/resources/niri-portals.conf -o niri-portals.conf
    sudo mkdir -p /usr/share/xdg-desktop-portal
    sudo mv niri-portals.conf /usr/share/xdg-desktop-portal/niri-portals.conf

    curl https://raw.githubusercontent.com/YaLTeR/niri/refs/heads/main/resources/niri.service -o niri.service
    sudo mv niri.service /etc/systemd/user/niri.service

    curl https://raw.githubusercontent.com/YaLTeR/niri/refs/heads/main/resources/niri-shutdown.target -o niri-shutdown.target
    sudo mv niri-shutdown.target /etc/systemd/user/niri-shutdown.target
}

noctalia_pam_setup() {
    echo ">>> noctalia: configure lock screen PAM"
    # noctalia links against nix's libpam, whose pam_unix.so hardcodes
    # /run/wrappers/bin/unix_chkpwd (NixOS-only path). We symlink it to the
    # system's setgid /usr/sbin/unix_chkpwd so password auth works on Ubuntu.
    # noctalia uses "noctalia" as PAM service name (patched in the nix derivation).

    sudo tee /etc/pam.d/noctalia <<'EOF'
#%PAM-1.0
# noctalia lock screen - Ubuntu 24.04 (non-NixOS home-manager)
# nix's pam_unix.so hardcodes /run/wrappers/bin/unix_chkpwd (NixOS path).
# We symlink it to /usr/sbin/unix_chkpwd (setgid shadow) via tmpfiles.d.
auth    required    pam_unix.so nullok
account required    pam_permit.so
session required    pam_permit.so
EOF

    sudo tee /etc/tmpfiles.d/noctalia-pam.conf <<'EOF'
d /run/wrappers     0755 root root -
d /run/wrappers/bin 0755 root root -
L+ /run/wrappers/bin/unix_chkpwd - - - - /usr/sbin/unix_chkpwd
EOF

    sudo systemd-tmpfiles --create /etc/tmpfiles.d/noctalia-pam.conf
}

# --- main ---
# Run a specific step:  ./ubuntu-bootstrap.sh gdm_setup
# Run everything:       ./ubuntu-bootstrap.sh

_all() {
    apt_setup
    nix_install
    apparmor_setup
    drivers_install
    tailscale_install
    niri_setup
    noctalia_pam_setup
    gdm_setup
    echo ">>> bootstrap complete"
}

if [[ $# -eq 0 ]]; then
    _all
else
    "$@"
fi
