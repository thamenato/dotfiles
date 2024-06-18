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
  };

  outputs = inputs@{ nixpkgs, home-manager, nixvim, ... }:
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
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        }
      );

      homeManagerSetup = username: system: (
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home-manager-modules
            nixvim.homeManagerModules.nixvim
          ];
        }
      );
    in
    {
      devShell."${system}" = pkgs.mkShell {
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
        thales-meer7 = nixosHost "thales-meer7" "thales";
      };

      homeConfigurations = {
        thamenato = homeManagerSetup "thamenato" "${system}";
        "thales@thales-meer7" = homeManagerSetup "thales" "${system}";
        "thales@thales-mac" = homeManagerSetup "thales" "${darwin}";
      };
    };
}
