# modules/home/programs/ncspot.nix
{...}: {
  flake.homeModules."programs/ncspot" = {...}: {
    programs.ncspot = {
      enable = true;

      settings = {
        initial_screen = "library";
        use_nerdfont = true;
        gapless = true;
      };
    };
  };
}
