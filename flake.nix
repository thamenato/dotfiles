{
  description = "My Dotfiles";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf.url = "github:notashelf/nvf";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    hyprland.url = "github:hyprwm/Hyprland";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    username = "thamenato";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

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
        zen-browser = inputs.zen-browser.packages."${system}".default;
        backgrounds = mkReadFolder ./misc/backgrounds;
      };

      modules = [
        inputs.nvf.homeManagerModules.default
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
        just
        yq
        nixpkgs-fmt
        sops
        nh
        # language server
        yaml-language-server
        nil
      ];
    };

    homeConfigurations = mkHomeConfigurations hostDirs;
  };
}
