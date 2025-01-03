{
  description = "My Dotfiles";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      darwin = "aarch64-darwin";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      darwin_pkgs = import nixpkgs {
        inherit darwin;
        config.allowUnfree = true;
      };

      # Import helper funcfions
      libx = import ./lib { inherit self inputs; };
    in
    {
      checks = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            check-added-large-files.enable = true;
            check-yaml.enable = true;
            deadnix.enable = true;
            detect-private-keys.enable = true;
            end-of-file-fixer.enable = true;
            nixfmt-rfc-style.enable = true;
            trim-trailing-whitespace.enable = true;
          };
        };
      };

      devShell."${system}" = pkgs.mkShell {
        inherit (self.checks.pre-commit-check) shellHook;
        buildInputs = self.checks.pre-commit-check.enabledPackages;

        packages = with pkgs; [
          # tools
          just
          yq
          nixpkgs-fmt
          pre-commit
          sops
          # language server
          yaml-language-server
          nil
        ];
      };

      devShell."${darwin}" = darwin_pkgs.mkShell { packages = with darwin_pkgs; [ pre-commit ]; };

      nixosConfigurations = {
        kassogtha = libx.mkHost { hostName = "kassogtha"; };
        zoth-ommog = libx.mkHost { hostName = "zoth-ommog"; };
        ythogtha = libx.mkHost { hostName = "ythogtha"; };
        thales-meer7 = libx.mkHost {
          hostName = "thales-meer7";
          user = "thales";
        };
      };

      homeConfigurations = {
        "thamenato@zoth-ommog" = libx.mkHome { hostName = "zoth-ommog"; };
        "thamenato@kassogtha" = libx.mkHome { hostName = "kassogtha"; };
        "thamenato@ythogtha" = libx.mkHome { hostName = "ythogtha"; };
        "thales@thales-meer7" = libx.mkHome { hostName = "thales-meer7"; };
      };
    };
}
