{
  backgrounds,
  config,
  lib,
  ...
}: {
  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = "${backgrounds."wallhaven-rrvygj_5120x1440.png"}";
      wallpapers = {
        "DP-2" = "${backgrounds."wallhaven-rrvygj_5120x1440.png"}";
        "eDP-1" = "${backgrounds."wallhaven-kxo38d_1920x1080.png"}";
      };
    };
  };
  programs.niri = {
    settings = {
      spawn-at-startup = [
        {argv = ["1password"];}
        {argv = ["slack"];}
      ];

      binds = with config.lib.niri.actions; {
        "Ctrl+Alt+L" = lib.mkForce {
          action = spawn "swaylock";
          hotkey-overlay.title = "Lock the Screen: swaylock";
        };
      };

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
