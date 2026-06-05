# modules/home/programs/alacritty/default.nix
{...}: {
  flake.homeModules."programs/alacritty" = {...}: {
    programs.alacritty = {
      enable = true;

      settings = {
        env = {
          TERM = "xterm-256color";
        };

        # window.padding = {
        #   x = 3;
        #   y = 3;
        # };
      };
    };
  };
}
