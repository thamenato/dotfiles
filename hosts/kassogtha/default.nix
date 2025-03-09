{
  lib,
  backgrounds,
  ...
}: {
  # home = {
  #   packages = with pkgs; [];
  # };

  wayland.windowManager = let
    output = "eDP-1";
    resolution = "1920x1080@144.00Hz";
  in {
    hyprland = {
      settings = {
        monitor = lib.mkForce ["${output},${resolution},auto,1"];
      };
    };
  };
  services.hyprpaper.settings = {
    preload = builtins.attrValues backgrounds;
    wallpaper = [",${backgrounds."wallhaven-kxo38d_1920x1080.png"}"];
  };
}
