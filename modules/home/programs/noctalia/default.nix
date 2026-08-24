# modules/home/programs/noctalia/default.nix
{...}: {
  flake.homeModules."programs/noctalia" = {
    backgroundsDir,
    profiles,
    lib,
    ...
  }: {
    # home-manager gained its own `programs.noctalia` module (modules/programs/noctalia.nix).
    # We stick with noctalia-shell's own home module, which ships alongside the flake
    # package we actually install, so disable the home-manager one to avoid a duplicate
    # option declaration.
    disabledModules = ["programs/noctalia.nix"];

    programs.noctalia = {
      enable = true;

      # Read as an attrset rather than handed over as a path, so hosts can
      # contribute their own `wallpaper.monitors.<connector>` entries; noctalia's
      # `settings` option merges nested tables across modules.
      settings = lib.mkMerge [
        (builtins.fromTOML (builtins.readFile ./noctalia-config.toml))
        {
          shell.avatar_path = "${profiles."zoth-shoulder-stare.png"}";
          wallpaper.directory = backgroundsDir;
        }
      ];
    };
  };
}
