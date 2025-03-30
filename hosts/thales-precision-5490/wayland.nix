{
  config,
  lib,
  pkgs,
  ...
}: {
  wayland.windowManager = {
    hyprland.enable = lib.mkForce false;
    sway = {
      enable = lib.mkForce true;
      package = config.lib.nixGL.wrap pkgs.sway;
    };
  };
}
