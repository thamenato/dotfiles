{
  description = "system76 meerkat7";

  inputs = {
    # unstable
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    # pkgs = nixpkgs.legacyPackages.${system};
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      zoth-ommog = lib.nixosSystem {
        inherit system;
        modules = [./configuration.nix];
      };
    };
    homeConfigurations = {
      thamenato = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home.nix];
      };
    };
  };
}
