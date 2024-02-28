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
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
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
      };

      # home-manager
      homeConfigurations = {
        thamenato = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            nixvim.homeManagerModules.nixvim
            ./home-manager/home.nix
          ];
        };
      };
    };
}
