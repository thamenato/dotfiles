{ inputs, ... }:
let
  system = "x86_64-linux";

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  hmPkgsConfig = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };

  mkHost =
    hostName: user:
    (inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        meta = {
          hostName = hostName;
          user = user;
        };
      };

      modules = [
        inputs.auto-cpufreq.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        inputs.disko.nixosModules.disko
        hmPkgsConfig
        ../nixos
        ../hosts/${hostName}/configuration.nix
      ];
    });

  mkHome =
    home_module_path:
    (inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        home_module_path
        inputs.nixvim.homeManagerModules.nixvim
      ];
    });
in
{
  mkHost = mkHost;
  mkHome = mkHome;
  # genNixos = builtins.mapAttrs mkHost;
  # genHome = builtins.mapAttrs mkHome;
}
