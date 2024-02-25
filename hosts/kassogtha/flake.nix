{
  description = "My dotfiles";

  inputs = {
    # unstable
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

  outputs = { self, nixpkgs, home-manager, nixvim, ... }: 
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs{
      	inherit system;
	config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        kassogtha = lib.nixosSystem {
          inherit system;
          modules = [ ./configuration.nix ];
        };
      };
      homeConfigurations = {
	thamenato = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
            nixvim.homeManagerModules.nixvim
            ./home.nix 
          ];
        };
      };
    };
}
