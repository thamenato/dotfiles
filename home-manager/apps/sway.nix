{
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4"; # super key
      terminal = "kitty";
      startup = [
        {command = "vivaldi";}
      ];
      outputs = {
        "DP-1" = {
          mode = "3840x1600@59.994Hz";
        };
        "HDMI-A-1" = {
          mode = "1920x1080@60Hz";
        };
      };
    };
  };
}
