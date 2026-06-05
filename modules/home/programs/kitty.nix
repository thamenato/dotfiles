# modules/home/programs/kitty.nix
{...}: {
  flake.homeModules."programs/kitty" = {...}: {
    programs.kitty = {
      enable = false;
      themeFile = "Chalk";
      settings = {
        cursor_shape = "block";
      };
      shellIntegration.mode = "no-cursor no-title";
    };
  };
}
