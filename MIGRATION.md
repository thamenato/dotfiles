# Migration Plan: flake-parts + import-tree

This document describes the migration of the dotfiles repository from a traditional
Home Manager flake structure to a modern flake-parts + import-tree architecture.

## Table of Contents

1. [Overview](#overview)
2. [Current State](#current-state)
3. [Target Architecture](#target-architecture)
4. [New Dependencies](#new-dependencies)
5. [Migration Checklist](#migration-checklist)
6. [Detailed Migration Steps](#detailed-migration-steps)
7. [File Conversion Reference](#file-conversion-reference)
8. [Testing Procedure](#testing-procedure)
9. [Rollback Plan](#rollback-plan)

---

## Overview

### Goals

- Replace manual import lists with automatic module discovery via `import-tree`
- Use `flake-parts` for better flake organization and `perSystem` handling
- Maintain all existing functionality (Home Manager configs, devShells, checks)
- Enable easier addition of new programs/features without editing import lists

### Non-Goals (for this migration)

- Adding NixOS configurations (Home Manager only)
- Using wrapper-modules (can be added later)
- Multi-architecture support beyond x86_64-linux

### Key Libraries

| Library | Purpose | Documentation |
|---------|---------|---------------|
| [flake-parts](https://flake.parts/) | Flake framework with module system | https://flake.parts/ |
| [import-tree](https://github.com/denful/import-tree) | Auto-import all .nix files in a directory | https://github.com/denful/import-tree |

---

## Current State

### Repository Structure (Before Migration)

```
/home/thamenato/dotfiles/
├── flake.nix              # Main entry point (115 lines)
├── flake.lock
├── utils.nix              # Helper functions (mkSwaybg, mkReadFolder, mkHome, mkHomeConfigurations)
├── Justfile
├── hosts/                 # Host-specific Home Manager configs
│   ├── kassogtha/
│   │   └── default.nix
│   ├── thales-precision-5490/
│   │   ├── default.nix
│   │   ├── packages.nix
│   │   ├── services.nix
│   │   ├── xdg.nix
│   │   └── programs/
│   │       ├── default.nix
│   │       ├── niri.nix
│   │       └── zen.nix
│   ├── ythogtha/
│   │   └── default.nix
│   └── zoth-ommog/
│       └── default.nix
├── home-manager/          # Shared Home Manager configuration
│   ├── default.nix        # Main import hub + home settings
│   ├── packages.nix
│   ├── stylix.nix
│   ├── dconf.nix
│   ├── gtk.nix
│   ├── qt.nix
│   ├── programs/          # 39 program modules
│   │   ├── default.nix    # Manual import list
│   │   ├── alacritty/
│   │   ├── atuin.nix
│   │   ├── bat.nix
│   │   ├── btop.nix
│   │   ├── claude-code.nix
│   │   ├── direnv.nix
│   │   ├── eza.nix
│   │   ├── fd.nix
│   │   ├── fzf.nix
│   │   ├── gh-dash.nix
│   │   ├── gh.nix
│   │   ├── ghostty.nix
│   │   ├── git.nix
│   │   ├── go.nix
│   │   ├── helix.nix
│   │   ├── hyprlock.nix
│   │   ├── k9s/
│   │   ├── kitty.nix
│   │   ├── lazygit.nix
│   │   ├── mergiraf.nix
│   │   ├── ncspot.nix
│   │   ├── nh.nix
│   │   ├── noctalia.nix
│   │   ├── nvf.nix
│   │   ├── opencode.nix
│   │   ├── ripgrep.nix
│   │   ├── rofi.nix
│   │   ├── ruff.nix
│   │   ├── swaylock.nix
│   │   ├── taskwarrior.nix
│   │   ├── tmux.nix
│   │   ├── vscode.nix
│   │   ├── waybar/
│   │   ├── yazi.nix
│   │   ├── zellij.nix
│   │   ├── zen.nix
│   │   ├── zoxide.nix
│   │   └── zsh/
│   ├── services/
│   │   ├── default.nix
│   │   ├── easyeffects.nix
│   │   ├── mako.nix
│   │   └── swayidle.nix
│   └── wayland/
│       ├── default.nix
│       ├── hyprland.nix
│       ├── niri.nix
│       └── sway.nix
├── misc/
│   ├── backgrounds/
│   └── profile/
└── scripts/
```

### Current Flake Inputs

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
  nvf = { url = "github:notashelf/nvf"; inputs.nixpkgs.follows = "nixpkgs"; };
  stylix = { url = "github:nix-community/stylix"; inputs.nixpkgs.follows = "nixpkgs"; };
  pre-commit-hooks = { url = "github:cachix/git-hooks.nix"; inputs.nixpkgs.follows = "nixpkgs"; };
  noctalia = { url = "github:noctalia-dev/noctalia-shell"; inputs.nixpkgs.follows = "nixpkgs"; inputs.noctalia-qs.follows = "noctalia-qs"; };
  noctalia-qs = { url = "github:noctalia-dev/noctalia-qs"; inputs.nixpkgs.follows = "nixpkgs"; };
  niri.url = "github:sodiboo/niri-flake";
  zen-browser.url = "github:0xc000022070/zen-browser-flake";
};
```

### Current Home Configurations

Generated via `utils.mkHomeConfigurations` for:
- `thamenato@kassogtha`
- `thamenato@thales-precision-5490`
- `thamenato@ythogtha`
- `thamenato@zoth-ommog`

### Current Special Args

```nix
extraSpecialArgs = {
  inherit inputs;
  backgrounds = mkReadFolder ./misc/backgrounds;
  utils = { inherit mkSwaybg; };
};
```

---

## Target Architecture

### Repository Structure (After Migration)

```
/home/thamenato/dotfiles/
├── flake.nix                          # Minimal entry (uses flake-parts + import-tree)
├── flake.lock
├── Justfile
├── modules/
│   ├── parts.nix                      # flake-parts config (systems)
│   ├── devshell.nix                   # devShells + pre-commit checks (perSystem)
│   ├── home/
│   │   ├── default.nix                # homeConfigurations definitions
│   │   ├── base.nix                   # flake.homeModules.base (shared config)
│   │   ├── packages.nix               # flake.homeModules.packages
│   │   ├── stylix.nix                 # flake.homeModules.stylix
│   │   ├── dconf.nix                  # flake.homeModules.dconf
│   │   ├── gtk.nix                    # flake.homeModules.gtk
│   │   ├── qt.nix                     # flake.homeModules.qt
│   │   ├── programs/
│   │   │   ├── alacritty/
│   │   │   │   └── default.nix        # flake.homeModules."programs/alacritty"
│   │   │   ├── atuin.nix              # flake.homeModules."programs/atuin"
│   │   │   ├── bat.nix
│   │   │   ├── btop.nix
│   │   │   ├── claude-code.nix
│   │   │   ├── direnv.nix
│   │   │   ├── eza.nix
│   │   │   ├── fd.nix
│   │   │   ├── fzf.nix
│   │   │   ├── gh-dash.nix
│   │   │   ├── gh.nix
│   │   │   ├── ghostty.nix
│   │   │   ├── git.nix
│   │   │   ├── go.nix
│   │   │   ├── helix.nix
│   │   │   ├── hyprlock.nix
│   │   │   ├── k9s/
│   │   │   │   └── default.nix
│   │   │   ├── kitty.nix
│   │   │   ├── lazygit.nix
│   │   │   ├── mergiraf.nix
│   │   │   ├── ncspot.nix
│   │   │   ├── nh.nix
│   │   │   ├── noctalia.nix
│   │   │   ├── nvf.nix
│   │   │   ├── opencode.nix
│   │   │   ├── ripgrep.nix
│   │   │   ├── rofi.nix
│   │   │   ├── ruff.nix
│   │   │   ├── swaylock.nix
│   │   │   ├── taskwarrior.nix
│   │   │   ├── tmux.nix
│   │   │   ├── vscode.nix
│   │   │   ├── waybar/
│   │   │   │   └── default.nix
│   │   │   ├── yazi.nix
│   │   │   ├── zellij.nix
│   │   │   ├── zen.nix
│   │   │   ├── zoxide.nix
│   │   │   └── zsh/
│   │   │       └── default.nix
│   │   ├── services/
│   │   │   ├── easyeffects.nix
│   │   │   ├── mako.nix
│   │   │   └── swayidle.nix
│   │   ├── wayland/
│   │   │   ├── hyprland.nix
│   │   │   ├── niri.nix
│   │   │   └── sway.nix
│   │   └── hosts/
│   │       ├── kassogtha/
│   │       │   └── default.nix        # flake.homeModules."hosts/kassogtha"
│   │       ├── thales-precision-5490/
│   │       │   ├── default.nix        # flake.homeModules."hosts/thales-precision-5490"
│   │       │   ├── packages.nix       # flake.homeModules."hosts/thales-precision-5490/packages"
│   │       │   ├── services.nix
│   │       │   ├── xdg.nix
│   │       │   └── programs/
│   │       │       ├── niri.nix
│   │       │       └── zen.nix
│   │       ├── ythogtha/
│   │       │   └── default.nix
│   │       └── zoth-ommog/
│   │           └── default.nix
├── misc/                              # Unchanged
│   ├── backgrounds/
│   └── profile/
└── scripts/                           # Unchanged
```

---

## New Dependencies

Add these to `flake.nix` inputs:

```nix
flake-parts = {
  url = "github:hercules-ci/flake-parts";
};

import-tree = {
  url = "github:denful/import-tree";
};
```

---

## Migration Checklist

Use this checklist to track progress. Mark items with `[x]` when complete.

### Phase 1: Setup New Structure

- [ ] **1.1** Create `modules/` directory
- [ ] **1.2** Create `modules/parts.nix` (flake-parts config)
- [ ] **1.3** Create `modules/devshell.nix` (migrate devShells + checks)
- [ ] **1.4** Update `flake.nix` with new inputs and output structure
- [ ] **1.5** Test that `nix flake check` passes (basic structure works)

### Phase 2: Create Home Module Infrastructure

- [ ] **2.1** Create `modules/home/default.nix` (homeConfigurations)
- [ ] **2.2** Create `modules/home/base.nix` (base homeModule)
- [ ] **2.3** Migrate `home-manager/packages.nix` → `modules/home/packages.nix`
- [ ] **2.4** Migrate `home-manager/stylix.nix` → `modules/home/stylix.nix`
- [ ] **2.5** Migrate `home-manager/dconf.nix` → `modules/home/dconf.nix`
- [ ] **2.6** Migrate `home-manager/gtk.nix` → `modules/home/gtk.nix`
- [ ] **2.7** Migrate `home-manager/qt.nix` → `modules/home/qt.nix`

### Phase 3: Migrate Programs (39 modules)

- [ ] **3.1** Create `modules/home/programs/` directory
- [ ] **3.2** Migrate `alacritty/` (directory with default.nix)
- [ ] **3.3** Migrate `atuin.nix`
- [ ] **3.4** Migrate `bat.nix`
- [ ] **3.5** Migrate `btop.nix`
- [ ] **3.6** Migrate `claude-code.nix`
- [ ] **3.7** Migrate `direnv.nix`
- [ ] **3.8** Migrate `eza.nix`
- [ ] **3.9** Migrate `fd.nix`
- [ ] **3.10** Migrate `fzf.nix`
- [ ] **3.11** Migrate `gh-dash.nix`
- [ ] **3.12** Migrate `gh.nix`
- [ ] **3.13** Migrate `ghostty.nix`
- [ ] **3.14** Migrate `git.nix`
- [ ] **3.15** Migrate `go.nix`
- [ ] **3.16** Migrate `helix.nix`
- [ ] **3.17** Migrate `hyprlock.nix`
- [ ] **3.18** Migrate `k9s/` (directory with default.nix)
- [ ] **3.19** Migrate `kitty.nix`
- [ ] **3.20** Migrate `lazygit.nix`
- [ ] **3.21** Migrate `mergiraf.nix`
- [ ] **3.22** Migrate `ncspot.nix`
- [ ] **3.23** Migrate `nh.nix`
- [ ] **3.24** Migrate `noctalia.nix`
- [ ] **3.25** Migrate `nvf.nix`
- [ ] **3.26** Migrate `opencode.nix`
- [ ] **3.27** Migrate `ripgrep.nix`
- [ ] **3.28** Migrate `rofi.nix`
- [ ] **3.29** Migrate `ruff.nix`
- [ ] **3.30** Migrate `swaylock.nix`
- [ ] **3.31** Migrate `taskwarrior.nix`
- [ ] **3.32** Migrate `tmux.nix`
- [ ] **3.33** Migrate `vscode.nix`
- [ ] **3.34** Migrate `waybar/` (directory with default.nix)
- [ ] **3.35** Migrate `yazi.nix`
- [ ] **3.36** Migrate `zellij.nix`
- [ ] **3.37** Migrate `zen.nix`
- [ ] **3.38** Migrate `zoxide.nix`
- [ ] **3.39** Migrate `zsh/` (directory with default.nix)

### Phase 4: Migrate Services (3 modules)

- [ ] **4.1** Create `modules/home/services/` directory
- [ ] **4.2** Migrate `easyeffects.nix`
- [ ] **4.3** Migrate `mako.nix`
- [ ] **4.4** Migrate `swayidle.nix` (has custom options!)

### Phase 5: Migrate Wayland (3 modules)

- [ ] **5.1** Create `modules/home/wayland/` directory
- [ ] **5.2** Migrate `hyprland.nix`
- [ ] **5.3** Migrate `niri.nix`
- [ ] **5.4** Migrate `sway.nix`

### Phase 6: Migrate Hosts (4 hosts)

- [ ] **6.1** Create `modules/home/hosts/` directory
- [ ] **6.2** Migrate `kassogtha/`
- [ ] **6.3** Migrate `thales-precision-5490/` (most complex - has subdirectories)
- [ ] **6.4** Migrate `ythogtha/`
- [ ] **6.5** Migrate `zoth-ommog/`

### Phase 7: Testing & Verification

- [ ] **7.1** Run `nix flake check`
- [ ] **7.2** Test build for `thamenato@kassogtha`
- [ ] **7.3** Test build for `thamenato@thales-precision-5490`
- [ ] **7.4** Test build for `thamenato@ythogtha`
- [ ] **7.5** Test build for `thamenato@zoth-ommog`
- [ ] **7.6** Test `nix develop` (devShell)
- [ ] **7.7** Actually switch to new config on primary machine

### Phase 8: Cleanup

- [ ] **8.1** Remove old `home-manager/` directory
- [ ] **8.2** Remove old `hosts/` directory
- [ ] **8.3** Remove `utils.nix`
- [ ] **8.4** Update Justfile if needed
- [ ] **8.5** Final commit

---

## Detailed Migration Steps

### Step 1.1: Create modules/ directory

```bash
mkdir -p modules/home/{programs,services,wayland,hosts}
```

### Step 1.2: Create modules/parts.nix

This file configures flake-parts basics.

```nix
# modules/parts.nix
{ ... }: {
  systems = [ "x86_64-linux" ];
}
```

### Step 1.3: Create modules/devshell.nix

Migrate devShell and pre-commit checks using `perSystem`.

```nix
# modules/devshell.nix
{ inputs, ... }: {
  perSystem = { pkgs, system, self', ... }: {
    checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
      src = ./.;
      hooks = {
        check-added-large-files.enable = true;
        check-yaml.enable = true;
        deadnix.enable = true;
        detect-private-keys.enable = true;
        end-of-file-fixer.enable = true;
        alejandra.enable = true;
        trim-trailing-whitespace.enable = true;
      };
    };

    devShells.default = pkgs.mkShell {
      inherit (self'.checks.pre-commit-check) shellHook;
      buildInputs = self'.checks.pre-commit-check.enabledPackages;

      packages = with pkgs; [
        # tools
        cachix
        just
        nh
        nixfmt
        sops
        yq-go
        # language server
        alejandra
        nil
        yaml-language-server
      ];
    };
  };
}
```

### Step 1.4: Update flake.nix

Replace the entire outputs section with flake-parts + import-tree.

```nix
# flake.nix
{
  description = "My Dotfiles";

  nixConfig = {
    fallback = true;

    extra-substituters = [
      "https://niri.cachix.org"
      "https://nix-cache.cthyllaxy.xyz"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "nix-cache.cthyllaxy.xyz:JIJkt6Drj50OAeIy/5XTbV0AP1d38IAanVkxjvTBTzY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # New inputs for migration
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.noctalia-qs.follows = "noctalia-qs";
    };

    noctalia-qs = {
      url = "github:noctalia-dev/noctalia-qs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # applications
    niri.url = "github:sodiboo/niri-flake";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; }
    (inputs.import-tree ./modules);
}
```

### Step 2.1: Create modules/home/default.nix

This is the central file that defines all homeConfigurations.

```nix
# modules/home/default.nix
{ self, inputs, ... }:
let
  system = "x86_64-linux";
  username = "thamenato";

  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  # Helper to read background files (migrated from utils.nix)
  mkReadFolder = dir:
    let
      fileList = builtins.readDir dir;
      mkFileAttr = name: type:
        if type == "regular"
        then "${dir}/${name}"
        else null;
    in
    pkgs.lib.filterAttrs (_name: value: value != null) (pkgs.lib.mapAttrs mkFileAttr fileList);

  # Helper for swaybg (migrated from utils.nix)
  mkSwaybg = outputs: {
    argv = [
      "${pkgs.swaybg}/bin/swaybg"
      "-m"
      "fill"
    ] ++ (pkgs.lib.concatMap (item: [
      "-o"
      item.output
      "-i"
      "${item.image}"
    ]) outputs);
  };

  backgrounds = mkReadFolder ../../misc/backgrounds;

  # Creates a home configuration for a specific host
  mkHome = hostName: inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    extraSpecialArgs = {
      inherit inputs backgrounds;
      utils = { inherit mkSwaybg; };
    };

    modules = [
      # External modules from flake inputs
      inputs.niri.homeModules.niri
      inputs.niri.homeModules.stylix
      inputs.noctalia.homeModules.default
      inputs.nvf.homeManagerModules.default
      inputs.stylix.homeModules.stylix
      inputs.zen-browser.homeModules.beta

      # Base configuration (shared by all hosts)
      self.homeModules.base

      # Host-specific configuration
      self.homeModules."hosts/${hostName}"
    ];
  };
in
{
  flake.homeConfigurations = {
    "${username}@kassogtha" = mkHome "kassogtha";
    "${username}@thales-precision-5490" = mkHome "thales-precision-5490";
    "${username}@ythogtha" = mkHome "ythogtha";
    "${username}@zoth-ommog" = mkHome "zoth-ommog";
  };
}
```

### Step 2.2: Create modules/home/base.nix

The base homeModule that all hosts inherit from.

```nix
# modules/home/base.nix
{ self, ... }: {
  flake.homeModules.base = { pkgs, lib, config, ... }: {
    imports = [
      # Core modules
      self.homeModules.packages
      self.homeModules.stylix
      self.homeModules.dconf
      self.homeModules.gtk
      self.homeModules.qt

      # All programs
      self.homeModules."programs/alacritty"
      self.homeModules."programs/atuin"
      self.homeModules."programs/bat"
      self.homeModules."programs/btop"
      self.homeModules."programs/claude-code"
      self.homeModules."programs/direnv"
      self.homeModules."programs/eza"
      self.homeModules."programs/fd"
      self.homeModules."programs/fzf"
      self.homeModules."programs/gh-dash"
      self.homeModules."programs/gh"
      self.homeModules."programs/ghostty"
      self.homeModules."programs/git"
      self.homeModules."programs/go"
      self.homeModules."programs/helix"
      self.homeModules."programs/hyprlock"
      self.homeModules."programs/k9s"
      self.homeModules."programs/kitty"
      self.homeModules."programs/lazygit"
      self.homeModules."programs/mergiraf"
      self.homeModules."programs/ncspot"
      self.homeModules."programs/nh"
      self.homeModules."programs/noctalia"
      self.homeModules."programs/nvf"
      self.homeModules."programs/opencode"
      self.homeModules."programs/ripgrep"
      self.homeModules."programs/rofi"
      self.homeModules."programs/ruff"
      self.homeModules."programs/swaylock"
      self.homeModules."programs/taskwarrior"
      self.homeModules."programs/tmux"
      self.homeModules."programs/vscode"
      self.homeModules."programs/waybar"
      self.homeModules."programs/yazi"
      self.homeModules."programs/zellij"
      self.homeModules."programs/zen"
      self.homeModules."programs/zoxide"
      self.homeModules."programs/zsh"

      # Services
      self.homeModules."services/easyeffects"
      self.homeModules."services/mako"
      self.homeModules."services/swayidle"

      # Wayland
      self.homeModules."wayland/hyprland"
      self.homeModules."wayland/niri"
      self.homeModules."wayland/sway"
    ];

    home = {
      username = "thamenato";
      homeDirectory = "/home/thamenato";

      shellAliases = {
        lg = "lazygit";
        man = "batman";
      };

      sessionVariables = {
        EDITOR = "nvim";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        OZONE_PLATFORM = "wayland";
        GDK_BACKEND = "wayland";
      };
    };

    fonts.fontconfig.enable = true;

    home.stateVersion = "22.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
```

---

## File Conversion Reference

### Converting a Simple Program Module

**Before** (`home-manager/programs/bat.nix`):
```nix
{ pkgs, ... }: {
  programs.bat = {
    enable = true;
    # ... config ...
  };
}
```

**After** (`modules/home/programs/bat.nix`):
```nix
{ self, ... }: {
  flake.homeModules."programs/bat" = { pkgs, ... }: {
    programs.bat = {
      enable = true;
      # ... config (unchanged) ...
    };
  };
}
```

### Converting a Directory Module (e.g., zsh/)

**Before** (`home-manager/programs/zsh/default.nix`):
```nix
{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    # ... config ...
  };
}
```

**After** (`modules/home/programs/zsh/default.nix`):
```nix
{ self, ... }: {
  flake.homeModules."programs/zsh" = { pkgs, ... }: {
    programs.zsh = {
      enable = true;
      # ... config (unchanged) ...
    };
  };
}
```

### Converting a Module with Custom Options (swayidle.nix)

**Before** (`home-manager/services/swayidle.nix`):
```nix
{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.swayidle;
in {
  options = {
    services.swayidle = {
      lockscreenCommand = mkOption {
        type = types.str;
        default = "hyprlock";
      };
    };
  };

  config = { /* ... */ };
}
```

**After** (`modules/home/services/swayidle.nix`):
```nix
{ self, ... }: {
  flake.homeModules."services/swayidle" = { lib, pkgs, config, ... }:
    with lib;
    let
      cfg = config.services.swayidle;
    in {
      options = {
        services.swayidle = {
          lockscreenCommand = mkOption {
            type = types.str;
            default = "hyprlock";
          };
        };
      };

      config = { /* ... unchanged ... */ };
    };
}
```

### Converting a Host Module

**Before** (`hosts/kassogtha/default.nix`):
```nix
{ backgrounds, utils, ... }: {
  wayland.windowManager.niri.settings = {
    # ... config ...
  };
}
```

**After** (`modules/home/hosts/kassogtha/default.nix`):
```nix
{ self, ... }: {
  flake.homeModules."hosts/kassogtha" = { backgrounds, utils, lib, ... }: {
    wayland.windowManager.niri.settings = {
      # ... config (unchanged) ...
    };
  };
}
```

### Converting a Complex Host (thales-precision-5490)

The host has multiple files. The main `default.nix` should import the others.

**After** (`modules/home/hosts/thales-precision-5490/default.nix`):
```nix
{ self, ... }: {
  # Main host module
  flake.homeModules."hosts/thales-precision-5490" = { pkgs, lib, ... }: {
    imports = [
      self.homeModules."hosts/thales-precision-5490/packages"
      self.homeModules."hosts/thales-precision-5490/services"
      self.homeModules."hosts/thales-precision-5490/xdg"
      self.homeModules."hosts/thales-precision-5490/programs/niri"
      self.homeModules."hosts/thales-precision-5490/programs/zen"
    ];

    targets.genericLinux.enable = true;

    # Host-specific overrides
    programs.go.enable = lib.mkForce false;
    # ... etc ...
  };
}
```

**After** (`modules/home/hosts/thales-precision-5490/packages.nix`):
```nix
{ self, ... }: {
  flake.homeModules."hosts/thales-precision-5490/packages" = { pkgs, ... }: {
    home.packages = with pkgs; [
      # ... host-specific packages ...
    ];
  };
}
```

---

## Testing Procedure

### After Each Phase

```bash
# Check flake validity
nix flake check

# List available outputs
nix flake show
```

### Testing Home Configurations

```bash
# Build without switching (safe)
nix build .#homeConfigurations."thamenato@kassogtha".activationPackage

# Build all hosts
nix build .#homeConfigurations."thamenato@thales-precision-5490".activationPackage
nix build .#homeConfigurations."thamenato@ythogtha".activationPackage
nix build .#homeConfigurations."thamenato@zoth-ommog".activationPackage

# Or use nh if preferred
nh home build . -- --flake .#thamenato@thales-precision-5490
```

### Testing DevShell

```bash
nix develop
# Should enter shell with pre-commit hooks active
```

### Final Switch

```bash
# Only after all tests pass!
home-manager switch --flake .#thamenato@thales-precision-5490
```

---

## Rollback Plan

If the migration fails at any point:

1. **Keep old structure intact** during migration (don't delete until Phase 8)
2. **Revert flake.nix** to original version
3. **Run** `nix flake lock --update-input nixpkgs` to refresh lock if needed
4. **Switch back** using old configuration

### Git Strategy

```bash
# Create migration branch
git checkout -b migrate-to-flake-parts

# Commit after each phase
git add -A && git commit -m "Phase X: description"

# If something breaks
git checkout main
```

---

## Notes & Gotchas

### import-tree Behavior

- Files/directories starting with `_` are **ignored** by import-tree
- Use `_helpers.nix` or `_lib/` for non-module utility files
- Every `.nix` file in `modules/` becomes a flake-parts module

### Module Naming Convention

The pattern `flake.homeModules."programs/git"` creates a nested attribute path.
Access it as `self.homeModules."programs/git"` from other modules.

### Special Args

`extraSpecialArgs` in `mkHome` makes these available to all home modules:
- `inputs` - All flake inputs
- `backgrounds` - Attribute set of wallpaper paths
- `utils` - Helper functions like `mkSwaybg`

### Common Errors

1. **"attribute 'homeModules' missing"** - The module defining that homeModule hasn't been created yet
2. **"infinite recursion"** - Usually a module importing itself or circular dependencies
3. **"option already declared"** - Two modules defining the same option (check for duplicate imports)

---

## Future Enhancements

After migration is complete, consider:

1. **wrapper-modules** for portable program configurations (niri, alacritty, etc.)
2. **NixOS support** by adding `modules/nixos/` directory
3. **Multi-arch** by expanding `systems` in parts.nix
4. **Auto-collection** of homeModules to avoid listing all 39 programs in base.nix

---

## References

- [Vimjoyer's Blog Post](https://www.vimjoyer.com/vid79-parts-wrapped)
- [flake-parts Documentation](https://flake.parts/)
- [import-tree Repository](https://github.com/denful/import-tree)
- [wrapper-modules Documentation](https://birdeehub.github.io/nix-wrapper-modules/md/intro.html)
- [Vimjoyer's nixconf](https://github.com/vimjoyer/nixconf) - Real-world example
