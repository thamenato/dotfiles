{
  lib,
  backgrounds,
  ...
}: {
  wayland.windowManager = let
    output = "HDMI-A-1";
    resolution = "3840x2160@120";
  in {
    hyprland = {
      settings = {
        monitor = lib.mkForce ["${output},${resolution},auto,1"];
      };
    };
  };
  services.hyprpaper.settings = {
    preload = builtins.attrValues backgrounds;
    wallpaper = [",${backgrounds."wallhaven-d6jzvg_3840x2160.png"}"];
  };
}
