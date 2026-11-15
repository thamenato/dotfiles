# dotfiles

![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)

My personal dotfiles, managed with home-manager and nix flakes. This repo only
builds `homeConfigurations`; NixOS system configs live elsewhere.

## Layout

- `modules/home/`: shared home-manager modules, auto-imported with
  flake-parts + import-tree.
- `modules/home/hosts/<hostname>/`: per-host config, registered in
  `modules/home/default.nix`.
- `scripts/ubuntu-bootstrap.sh`: sets up a fresh Ubuntu install.

## Usage

Build first, then switch:

```shell
nix build ".#homeConfigurations.\"$USER@$(hostname)\".activationPackage" --no-link
nh home switch . -a
```

## New Ubuntu host

```shell
scripts/ubuntu-bootstrap.sh   # prints status and the next command to run
just new-host                 # copy a host template for this machine
just doctor                   # read-only health check
```

The bootstrap runs in three phases, with `just new-host` and `nh home switch`
between phases 2 and 3.
