{
  programs.niri = {
    settings = {
      spawn-at-startup = [
        {argv = ["1password"];}
      ];

      outputs = {
        "DP-2" = {
          mode = {
            width = 5120;
            height = 1440;
            refresh = 120.000;
          };
          position = {
            x = 0;
            y = 0;
          };
        };
        "eDP-1" = {
          mode = {
            width = 1920;
            height = 1200;
            refresh = 60.026;
          };
          position = {
            x = 5120;
            y = 0;
          };
        };
      };
    };
  };
}
