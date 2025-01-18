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
    home-manager.backupFileExtension = "bak";
  };

  mkHost =
    {
      hostName,
      user ? "thamenato",
    }:
    (inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
        meta = {
          hostName = hostName;
          user = user;
        };
      };

      modules = [
        inputs.auto-cpufreq.nixosModules.default
        inputs.home-manager.nixosModules.home-manager
        inputs.disko.nixosModules.disko
        inputs.sops-nix.nixosModules.sops
        hmPkgsConfig
        ../nixos
        ../hosts/${hostName}/configuration.nix
      ];
    });

  mkHome =
    { hostName }:
    (inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        inputs.nvf.homeManagerModules.default
        ../home-manager
        ../hosts/${hostName}/home.nix
      ];
    });
in
{
  mkHost = mkHost;
  mkHome = mkHome;
  # genNixos = builtins.mapAttrs mkHost;
  # genHome = builtins.mapAttrs mkHome;
}
