{
  backgrounds,
  utils,
  ...
}: let
  background = utils.mkSwaybg [
    {
      output = "DP-2";
      image = "${backgrounds."wallhaven-kxo38d_1920x1080.png"}";
    }
    {
      output = "eDP-1";
      image = "${backgrounds."wallhaven-rrvygj_5120x1440.png"}";
    }
  ];
in {
  programs.niri = {
    settings = {
      spawn-at-startup = [
        background
        {argv = ["1password"];}
      ];

      outputs = {
        "DP-2" = {
          # monitor
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
          # laptop
          mode = {
            width = 1920;
            height = 1200;
            refresh = 60.026;
          };
          scale = 1;
          position = {
            x = 5120;
            y = 0;
          };
        };
      };
    };
  };
}
