# modules/home/programs/noctalia/default.nix
{...}: {
  flake.homeModules."programs/noctalia" = {...}: {
    programs.noctalia = {
      enable = true;
      settings = ./noctalia-config.toml;
    };
  };
}
