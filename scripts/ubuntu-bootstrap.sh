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
#   ./ubuntu-bootstrap.sh doctor       # read-only health check (also: just doctor)
#   ./ubuntu-bootstrap.sh gdm_setup    # or run any single step by name

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
NIX_ZSH="$HOME/.nix-profile/bin/zsh"
NIX_NIRI="$HOME/.nix-profile/bin/niri"
NVIDIA_DRIVER="${NVIDIA_DRIVER:-nvidia-driver-580-open}"

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
# No `grep -q`: under pipefail it can exit before lspci finishes writing,
# and lspci's SIGPIPE then makes the whole test fail on an NVIDIA host.
has_nvidia() { lspci 2>/dev/null | grep -iE '(vga|3d).*nvidia' >/dev/null; }

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
    # `sudo -v` prompts even under NOPASSWD when another sudoers rule (e.g.
    # %sudo) still wants a password, so try a no-op non-interactively first.
    sudo -n true 2>/dev/null || sudo -v || die "sudo is required"
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
    # build-essential: a fresh desktop install has no gcc, and the NVIDIA DKMS
    # build fails its CC sanity check without the compiler the kernel used.
    sudo apt-get install -y \
        build-essential \
        curl \
        git
    ok "build-essential, curl and git installed"
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
    nvidia_install
    ok "installed -- needs a reboot to load"
}

nvidia_install() {
    # ubuntu-drivers only installs what its modalias list knows. Newer GPUs
    # (e.g. the RTX PRO 500 Blackwell in the ThinkPad P14s Gen 6) are missing
    # from it, so it silently installs no NVIDIA driver at all.
    has_nvidia || return 0

    if ! dpkg -l 'nvidia-driver-*' 2>/dev/null | grep -q '^ii'; then
        step "nvidia: ubuntu-drivers skipped the GPU, installing $NVIDIA_DRIVER"
        # The prebuilt, signed module for the running kernel avoids DKMS where
        # it exists; DKMS still covers any other installed kernels.
        sudo apt-get install -y "$NVIDIA_DRIVER"
        sudo apt-get install -y "linux-modules-${NVIDIA_DRIVER#nvidia-driver-}-$(uname -r)" ||
            warn "no prebuilt module for $(uname -r) -- relying on DKMS"
    fi

    # nvidia_drm (the driver package sets modeset=1) froze boot on the P14s
    # Gen 6 at the gdm handoff. The dGPU drives no outputs and niri renders on
    # the iGPU, so keep compute (nvidia, nvidia_uvm) but never load KMS.
    sudo tee /etc/modprobe.d/zz-no-nvidia-drm.conf >/dev/null <<'EOF'
# Written by ubuntu-bootstrap.sh: nvidia_drm froze boot on hybrid laptops.
blacklist nvidia_drm
install nvidia_drm /bin/false
EOF
    sudo update-initramfs -u -k all
    ok "nvidia compute driver installed, nvidia_drm blocked"
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
    info "    just new-host        # scaffold this host's module (first time only)"
    info "    nh home switch       # builds the home-manager generation"
    info ""
    info "'just new-host' clones the glyd-24ba7c module and registers"
    info "'$USER@$(hostname)' in flake.homeConfigurations. Without that entry the"
    info "switch fails. Review the monitor/kanshi bits it prints before switching."
    info ""
    info "Once the switch finishes, come back and run:"
    info ""
    info "    ./scripts/ubuntu-bootstrap.sh phase3"
}

nix_install() {
    step "nix: install Determinate Nix"
    # --determinate installs Determinate Systems' Nix distribution (determinate-nixd,
    # /etc/nix/nix.conf managed by the installer) rather than upstream Nix.
    if has_nix; then
        ok "/nix already exists, skipping installer"
    else
        # --no-confirm: without a TTY (e.g. over ssh) the installer refuses to run.
        curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm
        ok "installed"
    fi

    # The daemon only honors the flake's extra-substituters (niri.cachix.org,
    # nix-cache.cthyllaxy.xyz, ...) for trusted users, and the installer leaves
    # trusted-users at root. nix.conf is overwritten on upgrades, so the line
    # goes in nix.custom.conf, which nix.conf includes.
    local line="trusted-users = root $USER"
    if grep -qxF "$line" /etc/nix/nix.custom.conf; then
        ok "$USER already a trusted nix user"
        return
    fi

    echo "$line" | sudo tee -a /etc/nix/nix.custom.conf >/dev/null
    sudo systemctl restart nix-daemon
    ok "added $USER to trusted-users"
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
    # noctalia uses "noctalia" as PAM service name (-Dpam_service in the host's
    # programs/default.nix).

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

    # sudo: a plain chsh asks for the user's password via PAM.
    sudo chsh -s "$NIX_ZSH" "$USER"
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
        info "       just new-host      # if this host has no module yet"
        info "       nh home switch"
    elif ! phase3_done; then
        info "Next:  ./scripts/ubuntu-bootstrap.sh phase3"
    else
        ok "All phases complete."
        doctor
        return
    fi
    printf '\n'
}

# --- doctor ---
# Read-only: never fixes anything and never prompts for sudo. Each failing
# check names the step that fixes it. Exits non-zero if any check fails.

doctor() {
    banner "DOCTOR"
    DOCTOR_FAILS=0

    _check_ubuntu_host
    _check_niri
    _check_noctalia_pam
    _check_gpu_drivers
    _check_nvidia

    printf '\n'
    if ((DOCTOR_FAILS == 0)); then
        ok "All checks passed."
        printf '\n'
        return 0
    fi
    warn "$DOCTOR_FAILS check(s) failed."
    printf '\n'
    return 1
}

_pass() { ok "$1"; }
_skip() { printf '\033[2m    - %s -- skipped: %s\033[0m\n' "$1" "$2"; }
_fail() {
    printf '\033[1;31m    x %s\033[0m\n' "$1"
    info "  fix: $2"
    DOCTOR_FAILS=$((DOCTOR_FAILS + 1))
}

# _expect NAME FIX TEST...: pass if TEST... succeeds, otherwise fail with FIX.
_expect() {
    local name=$1 fix=$2
    shift 2
    if "$@"; then _pass "$name"; else _fail "$name" "$fix"; fi
}

_nix() {
    if command -v nix >/dev/null 2>&1; then
        nix "$@" 2>/dev/null
    else
        /nix/var/nix/profiles/default/bin/nix "$@" 2>/dev/null
    fi
}

_home_attr() { printf '%s@%s' "$USER" "$(hostname)"; }

_check_ubuntu_host() {
    local me="./scripts/ubuntu-bootstrap.sh"
    _expect "nix installed" "$me phase2" has_nix

    if has_nix; then
        _expect "$(_home_attr) in flake.homeConfigurations" "just new-host" _has_home_config
    else
        _skip "$(_home_attr) in flake.homeConfigurations" "no nix"
    fi

    _expect "home-manager generation active" "cd $DOTFILES && nh home switch" has_home_manager
    _expect "niri wayland session registered" "$me niri_setup" has_niri_session
    _expect "display-manager.service is gdm" "$me gdm_setup" _dm_is_gdm
    _expect "login shell is the nix zsh (and in /etc/shells)" "$me zsh_setup" _zsh_ok
}

_has_home_config() {
    _nix eval --json "$DOTFILES#homeConfigurations" --apply builtins.attrNames |
        grep -F "\"$(_home_attr)\"" >/dev/null
}

_dm_is_gdm() {
    [[ "$(readlink -f /etc/systemd/system/display-manager.service)" == */gdm.service ]]
}

_zsh_ok() { login_shell_is_nix_zsh && grep -qxF "$NIX_ZSH" /etc/shells; }

_check_niri() {
    local unit="$HOME/.config/systemd/user/niri.service"
    _expect "niri.service comes from home-manager with X-SwitchMethod=keep-old" \
        "add the niri.service override (see modules/home/hosts/glyd-24ba7c/programs/niri.nix), then nh home switch" \
        _niri_unit_ok "$unit"
    _expect "no stray niri.service outside a niri login session" \
        "systemctl --user stop niri.service, then log in to niri again" \
        _no_stray_niri
}

_niri_unit_ok() {
    [[ "$(readlink -f "$1")" == /nix/store/* ]] &&
        grep -qxF 'X-SwitchMethod=keep-old' "$1"
}

# After a switch restarts niri, sd-switch can leave niri.service running with
# no session behind it; niri-session then refuses to start at the next login.
# A real login keeps the niri-session wrapper alive for the whole session (gdm
# leaves logind's Desktop property empty, so that can't be used instead).
_no_stray_niri() {
    systemctl --user is-active --quiet niri.service || return 0
    pgrep -u "$USER" -f 'bin/niri-session' >/dev/null
}

_check_noctalia_pam() {
    _expect "/etc/pam.d/noctalia and the unix_chkpwd wrapper in place" \
        "./scripts/ubuntu-bootstrap.sh noctalia_pam_setup" _pam_files_ok

    local helper
    helper="$(dirname "$(readlink -f "$HOME/.nix-profile/bin/noctalia" 2>/dev/null || echo /nonexistent)")/../libexec/noctalia/noctalia-pam-helper"
    if [[ ! -f "$helper" ]]; then
        _skip "noctalia PAM helper uses the 'noctalia' service" "helper not found"
        return
    fi
    _expect "noctalia PAM helper uses the 'noctalia' service" \
        "set mesonFlags -Dpam_service=noctalia in the host's programs/default.nix, then nh home switch" \
        _pam_helper_ok "$helper"
}

_pam_files_ok() {
    [[ -f /etc/pam.d/noctalia ]] &&
        [[ "$(readlink /run/wrappers/bin/unix_chkpwd)" == /usr/sbin/unix_chkpwd ]]
}

# The service name is compiled in as a NUL-terminated string literal.
_pam_helper_ok() {
    local strings
    strings="$(tr '\0' '\n' <"$1")"
    grep -qx noctalia <<<"$strings" && ! grep -qx login <<<"$strings"
}

_check_gpu_drivers() {
    local name="/run/opengl-driver matches this generation's GPU drivers"
    if ! has_nix; then
        _skip "$name" "no nix"
        return
    fi
    local want
    want="$(_nix eval --raw "$DOTFILES#homeConfigurations.\"$(_home_attr)\".config.targets.genericLinux.gpu.drivers")" || true
    if [[ -z "$want" ]]; then
        _skip "$name" "targets.genericLinux.gpu not enabled"
        return
    fi
    _expect "$name" "just gpu-setup" test "$(readlink /run/opengl-driver)" = "$want"
}

_check_nvidia() {
    if ! has_nvidia; then
        _skip "NVIDIA checks" "no NVIDIA GPU"
        return
    fi
    _expect "NVIDIA driver package installed" \
        "./scripts/ubuntu-bootstrap.sh nvidia_install" _nvidia_pkg_installed
    _expect "nvidia module built for $(uname -r)" \
        "sudo apt-get install linux-modules-${NVIDIA_DRIVER#nvidia-driver-}-$(uname -r) (or check DKMS)" \
        _nvidia_module_built
    _expect "nvidia_drm blocked and not loaded" \
        "./scripts/ubuntu-bootstrap.sh nvidia_install, then reboot" _nvidia_drm_blocked
}

_nvidia_pkg_installed() {
    dpkg -l 'nvidia-driver-*' 2>/dev/null | grep '^ii' >/dev/null
}

_nvidia_module_built() { modinfo nvidia >/dev/null 2>&1; }

_nvidia_drm_blocked() {
    grep -hqx 'install nvidia_drm /bin/false' /etc/modprobe.d/*.conf 2>/dev/null &&
        ! grep -q '^nvidia_drm ' /proc/modules
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
