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
            # laptop
            bg = "${backgrounds."wallhaven-kxo38d_1920x1080.png"} fit";
            pos = "5120 0";
          };
          "DP-2" = {
            # external
            bg = "${backgrounds."wallhaven-rrvygj_5120x1440.png"} center";
            pos = "0 0";
          };
        };
      };
    };
  };
}
