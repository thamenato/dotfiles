{
  description = "My Dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , nixvim
    , ...
    }:
    let
      system = "x86_64-linux";
      darwin = "aarch64-darwin";
      lib = nixpkgs.lib;

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      darwin_pkgs = import nixpkgs {
        system = "${darwin}";
        config.allowUnfree = true;
      };
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

      # nixos hosts
      nixosConfigurations = {
        kassogtha = lib.nixosSystem {
          inherit system;

          modules = [ ./hosts/kassogtha/configuration.nix ];
        };
        zoth-ommog = lib.nixosSystem {
          inherit system;

          modules = [ ./hosts/zoth-ommog/configuration.nix ];
        };
        thales-meer7 = lib.nixosSystem {
          inherit system;

          modules = [ ./hosts/meer7/configuration.nix ];
        };
      };

      # home-manager
      homeConfigurations = {
        thamenato = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            nixvim.homeManagerModules.nixvim
            ./home-manager-modules
          ];
        };
        "thales@thales-meer7" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            nixvim.homeManagerModules.nixvim
            ./hosts/meer7/home.nix
          ];
        };
        "thales@thales-mac" = home-manager.lib.homeManagerConfiguration {
          pkgs = darwin_pkgs;

          modules = [
            nixvim.homeManagerModules.nixvim
            ./hosts/mac/home.nix
          ];
        };
      };
    };
}
