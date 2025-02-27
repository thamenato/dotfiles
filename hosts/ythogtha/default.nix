{
  lib,
  backgrounds,
  ...
}: {
  wayland.windowManager = let
    qhdUltraWide = "5120x1440@120";
  in {
    hyprland = {
      settings = {
        monitor = lib.mkForce [",${qhdUltraWide},auto,1"];
      };
    };
  };
  services.hyprpaper.settings = {
    preload = builtins.attrValues backgrounds;
    wallpaper = [",${backgrounds."wallhaven-oxlo85_5120x1440.png"}"];
  };
}
