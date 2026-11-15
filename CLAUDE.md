# dotfiles

Home-manager config for every host. NixOS system configs live elsewhere; this repo only builds `homeConfigurations`.

## Repo

- flake-parts + import-tree: every `.nix` file under `modules/` is auto-imported and defines `flake.homeModules."<path>"`. Hosts are under `modules/home/hosts/<hostname>/` and registered in `modules/home/default.nix`.
- Build before switching so errors show up without touching the running session: `nix build '.#homeConfigurations."$USER@$(hostname)".activationPackage' --no-link`. Then run `nh home switch . -a`.
- Run long builds in a real terminal, never through Claude's `!` prefix. It has a time limit and cuts output off silently, so a killed build looks like a hang.
- Commit straight to `main` in this repo; no feature branches or worktrees. Pre-commit (alejandra, deadnix, ...) runs on commit.
- Zen spaces/containers are written by an activation script that skips silently while Zen is running. If one is missing, quit Zen and switch again.

## Non-NixOS (Ubuntu) hosts

- **Troubleshoot with `just doctor` first.** It's read-only and each failing check names the step that fixes it.
- Bootstrap with `scripts/ubuntu-bootstrap.sh` in three phases, with a manual `just new-host` + `nh home switch` between phases 2 and 3. Running it with no args prints status and the next command.
- When editing that script: keep it bash, keep `status` as the no-arg default, dispatch by function name, never add `BASH_SOURCE` guards, and keep the guards that run before any `sudo`.
- The stack is always niri + noctalia, with Determinate Nix as the installer (not lix). `wayland/sway.nix` is unimported on purpose and kept as a reference; swaylock/swayidle/swaybg are not sway leftovers.
- Prefer nix-profile binaries: register them with the system (e.g. `~/.nix-profile/bin/zsh` in `/etc/shells`) rather than apt-installing a duplicate.
- The noctalia lock screen authenticates against the `noctalia` PAM service (`mesonFlags` `-Dpam_service=noctalia` in the host's `programs/default.nix`), because nix's libpam can't parse Ubuntu's `@include` files. Journal lines like `PAM (other) illegal module type: @include` are harmless. Only a real lock→unlock proves PAM works.
- niri must come from our nixpkgs (`pkgs.niri`, set in `wayland/niri.nix`), or it can't load the mesa that `gpu-setup` installs.
- `~/.config/systemd/user/niri.service` needs `X-SwitchMethod=keep-old`. Without it, a switch run inside niri kills the session and leaves a stray `niri.service` behind, and the next login fails with "A niri session is already running". Fix: `systemctl --user stop niri.service`, then log in again.
- After a switch that changes mesa or drivers, run `just gpu-setup` (it updates `/run/opengl-driver`).

### NVIDIA hosts

Any host where `lspci` shows an NVIDIA GPU.

- Ubuntu: `ubuntu-drivers` skips new GPUs (e.g. Blackwell), so `nvidia_install` falls back to installing `nvidia-driver-580-open` directly.
- Ubuntu: `nvidia_drm` is blocked in `/etc/modprobe.d/zz-no-nvidia-drm.conf` because it froze boot at the gdm handoff on a hybrid laptop. Keep it blocked.
- On hybrid laptops niri renders on the iGPU and ignores the dGPU's render node (`debug.ignore-drm-device` in the host's `programs/niri.nix`), so the dGPU can reach runtime D3.
