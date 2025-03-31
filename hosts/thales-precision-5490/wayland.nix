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
          "DP-2" = {
            bg = "${backgrounds."wallhaven-rrvygj_5120x1440.png"} center";
          };
          "eDP-1" = {
            bg = "${backgrounds."wallhaven-kxo38d_1920x1080.png"} center";
          };
        };
      };
    };
  };
}
