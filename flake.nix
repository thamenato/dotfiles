{
  description = "My Dotfiles";

  nixConfig = {
    extra-substituters = [
      "https://nix-cache.cthyllaxy.xyz"
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-cache.cthyllaxy.xyz:JIJkt6Drj50OAeIy/5XTbV0AP1d38IAanVkxjvTBTzY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    # needed for non-NixOS host
    nixGL = {
      # using my own fork which includes patches
      # due to nix-community/nixGL being abandoned
      url = "github:thamenato/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # applications
    niri.url = "github:sodiboo/niri-flake";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixGL,
    ...
  }: let
    system = "x86_64-linux";
    username = "thamenato";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    utils = import ./utils.nix {inherit pkgs;};

    mkReadFolder = dir: let
      fileList = builtins.readDir dir;
      mkFileAttr = name: type:
        if type == "regular"
        then "${dir}/${name}"
        else null;
    in
      pkgs.lib.filterAttrs (_name: value: value != null) (pkgs.lib.mapAttrs mkFileAttr fileList);

    mkHome = {hostName}: (inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit nixGL utils;
        backgrounds = mkReadFolder ./misc/backgrounds;
      };

      modules = [
        inputs.nixvim.homeModules.nixvim
        inputs.niri.homeModules.niri
        inputs.niri.homeModules.stylix
        inputs.stylix.homeModules.stylix
        inputs.zen-browser.homeModules.beta
        ./home-manager
        ./hosts/${hostName}
      ];
    });

    mkHomeConfigurations = hosts:
      builtins.listToAttrs (
        map
        (hostName: {
          name = "${username}@${hostName}";
          value = mkHome {inherit hostName;};
        })
        hosts
      );

    hostDirs = builtins.attrNames (builtins.readDir ./hosts);
  in {
    checks = {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
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
    };

    devShell."${system}" = pkgs.mkShell {
      inherit (self.checks.pre-commit-check) shellHook;
      buildInputs = self.checks.pre-commit-check.enabledPackages;

      packages = with pkgs; [
        # tools
        cachix
        just
        nh
        nixpkgs-fmt
        sops
        yq-go
        # language server
        nil
        yaml-language-server
      ];
    };

    homeConfigurations = mkHomeConfigurations hostDirs;
  };
}
