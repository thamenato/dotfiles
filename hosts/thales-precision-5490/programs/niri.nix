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
        "eDP-1" = {
          # laptop (left)
          mode = {
            width = 1920;
            height = 1200;
            refresh = 60.026;
          };
          scale = 1;
          position = {
            x = 0;
            y = 0;
          };
        };
        "DP-3" = {
          # sceptre (middle)
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.000;
          };
          position = {
            x = 1920;
            y = 0;
          };
        };
        "DP-2" = {
          # portable (right)
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.000;
          };
          position = {
            x = 1920 * 2;
            y = 0;
          };
        };
      };
    };
  };
}
