#!/usr/bin/env bash
set -euo pipefail

# Bootstrap a fresh Ubuntu install into the niri + noctalia setup.
#
# This CANNOT run as one command: nix has to be installed and `nh home switch`
# has to finish before the last phase has any binaries to point at. So it is
# split into three phases, with a manual step between phase 2 and phase 3.
#
#   ./ubuntu-bootstrap.sh              # show where you are and what to run next
#   ./ubuntu-bootstrap.sh phase1       # apt, tailscale, apparmor, gpu drivers
#   ./ubuntu-bootstrap.sh phase2       # Determinate Nix
#   ./ubuntu-bootstrap.sh phase3       # niri session, noctalia PAM, gdm, zsh
#   ./ubuntu-bootstrap.sh gdm_setup    # or run any single step by name

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
NIX_ZSH="$HOME/.nix-profile/bin/zsh"
NIX_NIRI="$HOME/.nix-profile/bin/niri"

# --- output helpers ---

step() { printf '\n\033[1;34m>>> %s\033[0m\n' "$*"; }
info() { printf '    %s\n' "$*"; }
ok() { printf '\033[1;32m    + %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m    ! %s\033[0m\n' "$*"; }
banner() { printf '\n\033[1;35m=== %s ===\033[0m\n' "$*"; }
die() {
    printf '\033[1;31m    x %s\033[0m\n' "$*" >&2
    exit 1
}

# --- state detection ---

has_nix() { [[ -d /nix/store ]]; }
has_home_manager() { [[ -x "$NIX_NIRI" ]]; }
has_niri_session() { [[ -e /usr/share/wayland-sessions/niri.desktop ]]; }
has_tailscale() { command -v tailscale >/dev/null 2>&1; }

userns_unrestricted() {
    [[ "$(sysctl -n kernel.apparmor_restrict_unprivileged_userns 2>/dev/null || echo 1)" == "0" ]]
}

login_shell_is_nix_zsh() {
    [[ "$(getent passwd "$USER" | cut -d: -f7)" == "$NIX_ZSH" ]]
}

phase1_done() { has_tailscale && userns_unrestricted; }
phase2_done() { has_nix; }
phase3_done() { has_niri_session && login_shell_is_nix_zsh; }

# --- preflight ---

preflight() {
    [[ $EUID -ne 0 ]] || die "do not run this as root -- it uses sudo where needed"
    command -v apt-get >/dev/null 2>&1 ||
        die "apt-get not found -- this script is for Ubuntu"
    sudo -v || die "sudo is required"
}

# --- phase 1: everything that only needs apt ---

phase1() {
    banner "PHASE 1 -- base system (apt only, no nix yet)"
    preflight
    apt_setup
    tailscale_install
    apparmor_setup
    drivers_install

    banner "PHASE 1 COMPLETE"
    info "Reboot now, to load the GPU driver you just installed:"
    info ""
    info "    sudo reboot"
    info ""
    info "After the reboot, continue with:"
    info ""
    info "    ./scripts/ubuntu-bootstrap.sh phase2"
}

apt_setup() {
    step "apt: update & install base packages"
    sudo apt-get update -y
    sudo apt-get upgrade -y
    sudo apt-get install -y \
        curl \
        git
    ok "curl and git installed"
}

tailscale_install() {
    step "tailscale: add repo and install"
    # Pure apt, so it belongs in phase 1 -- nothing here needs nix.
    if has_tailscale; then
        ok "already installed, skipping"
        return
    fi

    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg |
        sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list |
        sudo tee /etc/apt/sources.list.d/tailscale.list >/dev/null
    sudo apt-get update -y
    sudo apt-get install -y tailscale

    ok "installed -- connect it later with: sudo tailscale up"
}

apparmor_setup() {
    step "apparmor: disable unprivileged userns restrictions"
    # Ubuntu 24.04 restricts unprivileged user namespaces, which breaks the nix
    # build sandbox. Writing the sysctl.d file only persists it -- we apply it
    # immediately too, so phase 2 works even before the reboot.
    echo 'kernel.apparmor_restrict_unprivileged_userns = 0' |
        sudo tee /etc/sysctl.d/20-apparmor-donotrestrict.conf >/dev/null
    sudo sysctl --system >/dev/null

    if userns_unrestricted; then
        ok "unprivileged userns allowed"
    else
        warn "sysctl written but not active -- it will apply after the reboot"
    fi
}

drivers_install() {
    step "drivers: install ubuntu-drivers"
    sudo ubuntu-drivers install
    ok "installed -- needs a reboot to load"
}

# --- phase 2: nix ---

phase2() {
    banner "PHASE 2 -- Determinate Nix"
    preflight
    nix_install

    banner "PHASE 2 COMPLETE"
    info "Nix is NOT on the PATH of this shell yet. Open a new terminal, then:"
    info ""
    info "    git clone <dotfiles-remote> $DOTFILES"
    info "    cd $DOTFILES"
    info "    nix develop          # gets you nh, just, sops"
    info "    nh home switch       # builds the home-manager generation"
    info ""
    info "Note: '$USER@$(hostname)' must exist in flake.homeConfigurations"
    info "(modules/home/default.nix) or the switch will fail."
    info ""
    info "Once the switch finishes, come back and run:"
    info ""
    info "    ./scripts/ubuntu-bootstrap.sh phase3"
}

nix_install() {
    step "nix: install Determinate Nix"
    # --determinate installs Determinate Systems' Nix distribution (determinate-nixd,
    # /etc/nix/nix.conf managed by the installer) rather than upstream Nix.
    # The installer also sets trusted-users, which the flake's extra-substituters
    # (niri.cachix.org, nix-cache.cthyllaxy.xyz) need in order to be honored.
    if has_nix; then
        ok "/nix already exists, skipping installer"
        return
    fi

    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
    ok "installed"
}

# --- phase 3: everything that needs the home-manager generation ---

phase3() {
    banner "PHASE 3 -- niri session, noctalia, gdm, zsh"
    preflight
    require_home_manager
    niri_setup
    noctalia_pam_setup
    gdm_setup
    zsh_setup

    banner "PHASE 3 COMPLETE"
    info "Last steps:"
    info ""
    info "    cd $DOTFILES && nix develop -c just gpu-setup"
    info "    sudo reboot"
    info ""
    info "At the login screen, pick the 'niri' session from the gear menu."
}

require_home_manager() {
    has_nix || die "nix is not installed -- run './scripts/ubuntu-bootstrap.sh phase2' first"
    has_home_manager ||
        die "$NIX_NIRI not found -- run 'nh home switch' in $DOTFILES first"
}

niri_setup() {
    step "niri: symlinks, wayland session, and systemd units"
    require_home_manager
    sudo ln -sf "$NIX_NIRI" /usr/bin/niri
    sudo ln -sf "$HOME/.nix-profile/bin/niri-session" /usr/bin/niri-session

    local base=https://raw.githubusercontent.com/YaLTeR/niri/refs/heads/main/resources
    local tmp
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' RETURN

    curl -fsSL "$base/niri.desktop" -o "$tmp/niri.desktop"
    sudo mkdir -p /usr/share/wayland-sessions
    sudo install -m644 "$tmp/niri.desktop" /usr/share/wayland-sessions/niri.desktop

    curl -fsSL "$base/niri-portals.conf" -o "$tmp/niri-portals.conf"
    sudo mkdir -p /usr/share/xdg-desktop-portal
    sudo install -m644 "$tmp/niri-portals.conf" /usr/share/xdg-desktop-portal/niri-portals.conf

    curl -fsSL "$base/niri.service" -o "$tmp/niri.service"
    sudo install -m644 "$tmp/niri.service" /etc/systemd/user/niri.service

    curl -fsSL "$base/niri-shutdown.target" -o "$tmp/niri-shutdown.target"
    sudo install -m644 "$tmp/niri-shutdown.target" /etc/systemd/user/niri-shutdown.target

    ok "niri session registered"
}

noctalia_pam_setup() {
    step "noctalia: configure lock screen PAM"
    # noctalia links against nix's libpam, whose pam_unix.so hardcodes
    # /run/wrappers/bin/unix_chkpwd (NixOS-only path). We symlink it to the
    # system's setgid /usr/sbin/unix_chkpwd so password auth works on Ubuntu.
    # noctalia uses "noctalia" as PAM service name (patched in the nix derivation).

    sudo tee /etc/pam.d/noctalia >/dev/null <<'EOF'
#%PAM-1.0
# noctalia lock screen - Ubuntu 24.04 (non-NixOS home-manager)
# nix's pam_unix.so hardcodes /run/wrappers/bin/unix_chkpwd (NixOS path).
# We symlink it to /usr/sbin/unix_chkpwd (setgid shadow) via tmpfiles.d.
auth    required    pam_unix.so nullok
account required    pam_permit.so
session required    pam_permit.so
EOF

    sudo tee /etc/tmpfiles.d/noctalia-pam.conf >/dev/null <<'EOF'
d /run/wrappers     0755 root root -
d /run/wrappers/bin 0755 root root -
L+ /run/wrappers/bin/unix_chkpwd - - - - /usr/sbin/unix_chkpwd
EOF

    sudo systemd-tmpfiles --create /etc/tmpfiles.d/noctalia-pam.conf
    ok "PAM service and unix_chkpwd wrapper in place"
}

gdm_setup() {
    step "gdm: use Ubuntu's default GNOME display manager"
    # We use stock gdm3 (Ubuntu default). gdm is the display manager here;
    # the wayland-sessions greeter lets us pick the niri session at login.
    # An Ubuntu update can wipe the /etc/systemd/system/display-manager.service
    # alias symlink, leaving the machine with no display manager -- so we set it
    # explicitly here rather than relying on the package to have done it.
    [[ -x /usr/sbin/gdm3 ]] || die "gdm3 not installed -- 'sudo apt-get install -y gdm3'"

    echo '/usr/sbin/gdm3' | sudo tee /etc/X11/default-display-manager >/dev/null
    sudo ln -sf /usr/lib/systemd/system/gdm.service \
        /etc/systemd/system/display-manager.service
    sudo systemctl daemon-reload
    ok "display-manager.service points at gdm"
}

zsh_setup() {
    step "zsh: register the nix zsh in /etc/shells and set it as the login shell"
    # home-manager's programs.zsh installs zsh into the nix profile and writes
    # ~/.zshrc, but it cannot change the login shell: chsh only accepts shells
    # listed in /etc/shells. So we register the nix-profile zsh there and chsh
    # to it -- no apt zsh needed, and the login shell is the same build the rest
    # of the config is pinned to.
    [[ -x "$NIX_ZSH" ]] ||
        die "$NIX_ZSH not found -- run 'nh home switch' in $DOTFILES first"

    if ! grep -qxF "$NIX_ZSH" /etc/shells; then
        echo "$NIX_ZSH" | sudo tee -a /etc/shells >/dev/null
        ok "added $NIX_ZSH to /etc/shells"
    fi

    if login_shell_is_nix_zsh; then
        ok "already the login shell, skipping chsh"
        return
    fi

    chsh -s "$NIX_ZSH" "$USER"
    ok "login shell set (takes effect on next login)"
}

# --- status ---

status() {
    banner "BOOTSTRAP STATUS"

    _check() {
        if "$1"; then ok "$2"; else warn "$2 -- not done"; fi
    }

    _check phase1_done "phase 1  base system (apt, tailscale, apparmor, drivers)"
    _check phase2_done "phase 2  nix installed"
    _check has_home_manager "manual   nh home switch"
    _check phase3_done "phase 3  niri session + login shell"

    printf '\n'
    if ! phase1_done; then
        info "Next:  ./scripts/ubuntu-bootstrap.sh phase1"
    elif ! phase2_done; then
        info "Next:  ./scripts/ubuntu-bootstrap.sh phase2"
    elif ! has_home_manager; then
        info "Next:  cd $DOTFILES && nix develop"
        info "       nh home switch"
    elif ! phase3_done; then
        info "Next:  ./scripts/ubuntu-bootstrap.sh phase3"
    else
        ok "All phases complete."
    fi
    printf '\n'
}

# --- main ---
# No arguments shows status and the next command to run. Any argument is
# treated as a function name, so single steps can be re-run on their own:
#   ./ubuntu-bootstrap.sh gdm_setup

if [[ $# -eq 0 ]]; then
    status
else
    "$@"
fi
