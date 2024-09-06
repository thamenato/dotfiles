{ self, inputs, ... }:
let
  system = "x86_64-linux";

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  mkHost = hostname: username: (
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ../hosts/${hostname}/configuration.nix
        inputs.auto-cpufreq.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    }
  );

  mkHome = home_module_path: (
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        home_module_path
        inputs.nixvim.homeManagerModules.nixvim
      ];
    }
  );
in
{
  mkHost = mkHost;
  mkHome = mkHome;
  # genNixos = builtins.mapAttrs mkHost;
  # genHome = builtins.mapAttrs mkHome;
}
