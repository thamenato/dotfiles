{
  config,
  lib,
  pkgs,
  backgrounds,
  ...
}: {
  wayland.windowManager = {
    hyprland.enable = lib.mkForce false;
    sway = {
      enable = lib.mkForce true;
      package = config.lib.nixGL.wrap pkgs.sway;
      config = {
        output = {
          "eDP-1" = {
            bg = "${backgrounds."wallhaven-kxo38d_1920x1080.png"} fit";
            pos = "0 0";
          };
          "DP-4" = {
            bg = "${backgrounds."wallhaven-kxo38d_1920x1080.png"} center";
            pos = "1920 0";
          };
        };
      };
    };
  };
}
