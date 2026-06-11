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

ly_setup() {
    echo ">>> ly: replace gdm/lightdm with a simple TUI display manager"
    # ly has no compositor greeter, so it releases DRM cleanly before the
    # user's Wayland session starts. Installed via nix; symlinked system-wide.
    sudo ln -sf "$(which ly)" /usr/bin/ly

    # ly looks for runtime files at /etc/ly/ but the nix package ships them in
    # the store with unresolvable $PREFIX_DIRECTORY/$CONFIG_DIRECTORY placeholders.
    # Copy config.ini and patch all placeholder paths; write a minimal setup.sh
    # instead of the nix store version (which uses $CONFIG_DIRECTORY internally).
    local ly_etc
    ly_etc="$(dirname "$(readlink -f "$(which ly)")")/../etc"
    sudo mkdir -p /etc/ly
    sudo cp "$ly_etc/config.ini" /etc/ly/config.ini

    sudo sed -i \
        -e 's|\$PREFIX_DIRECTORY/share/wayland-sessions|/usr/share/wayland-sessions|g' \
        -e 's|\$PREFIX_DIRECTORY/share/xsessions|/usr/share/xsessions|g' \
        -e 's|\$PREFIX_DIRECTORY/bin/X|/usr/bin/X|g' \
        -e 's|\$PREFIX_DIRECTORY/bin/xauth|/usr/bin/xauth|g' \
        -e 's|\$CONFIG_DIRECTORY|/etc|g' \
        -e 's|^setup_cmd = .*|setup_cmd = /etc/ly/setup.sh|' \
        -e 's|^start_cmd = .*|start_cmd = null|' \
        /etc/ly/config.ini

    sudo tee /etc/ly/setup.sh << 'EOF'
#!/bin/sh
# pam_systemd starts the user manager async; wait for the bus socket
i=0
while [ $i -lt 20 ] && [ ! -S "${XDG_RUNTIME_DIR}/bus" ]; do
    sleep 0.2
    i=$((i + 1))
done
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
exec "$@"
EOF
    sudo chmod +x /etc/ly/setup.sh

    sudo tee /etc/systemd/system/ly.service <<'EOF'
[Unit]
Description=TUI display manager
After=systemd-user-sessions.service
After=plymouth-quit-wait.service
After=getty@tty2.service
Conflicts=getty@tty2.service

[Service]
Type=idle
ExecStart=/usr/bin/ly
StandardInput=tty
TTYPath=/dev/tty2
TTYReset=yes
TTYVHangup=yes

[Install]
Alias=display-manager.service
EOF

    # ly is the nix binary, so it links nix's libpam, whose module search dir
    # (/nix/store/...linux-pam.../lib/security) ships only pam_unix.so -- NOT
    # pam_systemd.so. So pam_systemd never loads at ly login (journal shows
    # "PAM adding faulty module: .../pam_systemd.so"), no logind session is
    # registered, and niri can't get a seat -- it loops "error doing early
    # import: DeviceMissing" / "Failed to open device: Operation not permitted"
    # on /dev/dri/card*, and "logind ... NoSuchSession".
    #
    # We can't use the SYSTEM pam_systemd.so: it pulls system libsystemd/libcap/
    # glibc into a nix-glibc process and won't load. But nixpkgs' systemd ships a
    # nix-built pam_systemd.so that loads cleanly into nix ly and registers a
    # real session with the system logind over dbus (ly already exports
    # XDG_VTNR/XDG_SEAT for seat assignment). Symlink it to a stable path and
    # point ly's PAM session stack at it by absolute path.
    # NOTE: not a gc-root -- if `nix-collect-garbage` removes the store path,
    # re-run this step to refresh the symlink.
    local nix_pam_systemd
    nix_pam_systemd="$(find /nix/store -maxdepth 4 -name 'pam_systemd.so' 2>/dev/null | head -1)"
    sudo ln -sf "$nix_pam_systemd" /etc/ly/pam_systemd.so

    sudo tee /etc/pam.d/ly <<'EOF'
#%PAM-1.0
auth       include      common-auth
account    include      common-account
password   include      common-password
session    include      common-session
session    optional     /etc/ly/pam_systemd.so
EOF

    # Belt-and-suspenders: lingering keeps user@UID.service (and its dbus bus)
    # up at boot, so a session is never left without a bus even if pam_systemd
    # ever regresses. Harmless alongside the proper logind session above.
    sudo loginctl enable-linger "$USER"

    sudo systemctl disable gdm lightdm 2>/dev/null || true
    sudo systemctl enable ly
    echo '/usr/bin/ly' | sudo tee /etc/X11/default-display-manager
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
# Run a specific step:  ./ubuntu-bootstrap.sh ly_setup
# Run everything:       ./ubuntu-bootstrap.sh

_all() {
    apt_setup
    nix_install
    apparmor_setup
    drivers_install
    tailscale_install
    niri_setup
    noctalia_pam_setup
    ly_setup
    echo ">>> bootstrap complete"
}

if [[ $# -eq 0 ]]; then
    _all
else
    "$@"
fi
