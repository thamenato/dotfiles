{
  lib,
  pkgs,
  ...
}: let
  disabled = lib.mkForce false;
  enabled = lib.mkForce true;
in {
  services = {
    hyprpaper.enable = disabled;
    easyeffects.enable = enabled;
    dunst = {
      # notification
      enable = true;

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = "16x16";
      };

      settings = {
        global = {
          width = 300;
          height = 300;
          offset = "30x50";
          origin = "top-right";
          transparency = 10;
          # frame_color = "#eceff1";
          frame_width = 2;
          font = "Hack 9";
        };

        urgency_normal = {
          # background = "#37474f";
          # foreground = "#eceff1";
          timeout = 15;
        };
      };
    };

    pasystray = {
      # sound tray
      enable = true;
    };
  };
}
