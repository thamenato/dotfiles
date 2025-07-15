{
  lib,
  config,
  pkgs,
  ...
}: let
  disabled = lib.mkForce false;
  enabled = lib.mkForce true;
in {
  imports = [
    ./ghostty.nix
  ];

  programs = {
    go.enable = disabled;
    rofi.enable = enabled;

    ncspot = {
      package = pkgs.emptyDirectory;
    };

    wezterm.package = config.lib.nixGL.wrap pkgs.wezterm;
  };
}
