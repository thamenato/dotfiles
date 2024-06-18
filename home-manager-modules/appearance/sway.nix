{ wayland, ... }:
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod4"; # super key
      terminal = "alacritty";

      startup = [
        { command = "vivaldi"; }
      ];

      output = {
        # "DP-1" = {
        #   mode = "3840x1600@59.994Hz";
        # };
        # "HDMI-A-1" = {
        #   mode = "1920x1080@60Hz";
        # };
      };
    };
  };
}
