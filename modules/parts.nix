# modules/parts.nix
# Basic flake-parts configuration
{lib, ...}: {
  # Declare homeModules as a mergeable option (flake-parts doesn't provide this by default)
  options.flake.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = {};
    description = "Home Manager modules that can be imported in homeConfigurations.";
  };

  config.systems = ["x86_64-linux"];
}
