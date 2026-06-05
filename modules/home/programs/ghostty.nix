# modules/home/programs/ghostty.nix
{...}: {
  flake.homeModules."programs/ghostty" = {...}: {
    programs.ghostty = {
      enable = false;

      enableZshIntegration = true;

      settings = {
        # window
        title = " ";
        background-opacity = 0.95;
      };
    };
  };
}
