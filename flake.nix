{
  description = "My Dotfiles";

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
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixvim, auto-cpufreq, ... }:
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

      nixosHost = hostname: username: (
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/${hostname}/configuration.nix
            auto-cpufreq.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        }
      );

      homeManagerSetup = home_module_path: (
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            home_module_path
            nixvim.homeManagerModules.nixvim
          ];
        }
      );

    in
    {
      checks = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            check-added-large-files.enable = true;
            check-yaml.enable = true;
            detect-private-keys.enable = true;
            end-of-file-fixer.enable = true;
            nixpkgs-fmt.enable = true;
            trim-trailing-whitespace.enable = true;
          };
        };
      };

      devShell."${system}" = pkgs.mkShell {
        inherit (self.checks.pre-commit-check) shellHook;
        buildInputs = self.checks.pre-commit-check.enabledPackages;

        packages = with pkgs; [
          # tools
          pre-commit
          nixpkgs-fmt
          # language server
          yaml-language-server
          nil
        ];
      };

      devShell."${darwin}" = darwin_pkgs.mkShell {
        packages = with darwin_pkgs; [
          pre-commit
        ];
      };

      nixosConfigurations = {
        kassogtha = nixosHost "kassogtha" "thamenato";
        zoth-ommog = nixosHost "zoth-ommog" "thamenato";
        thales-meer7 = nixosHost "meer7" "thales";
      };

      homeConfigurations = {
        thamenato = homeManagerSetup ./home-manager-modules;
        "thamenato@kassogtha" = homeManagerSetup ./hosts/kassogtha/home.nix;
        "thales@thales-meer7" = homeManagerSetup ./hosts/meer7/home.nix;
      };
    };
}
