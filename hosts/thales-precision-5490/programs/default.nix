{
  lib,
  config,
  pkgs,
  zen-browser,
  ...
}: let
  disabled = lib.mkForce false;
  enabled = lib.mkForce true;
in {
  imports = [
    ./ghostty.nix
    ./git.nix
    ./niri.nix
  ];

  programs = {
    go.enable = disabled;
    rofi.enable = enabled;
    zen-browser.package = config.lib.nixGL.wrapOffload zen-browser;

    ncspot = {
      package = pkgs.emptyDirectory;
    };

    wezterm.package = config.lib.nixGL.wrapOffload pkgs.wezterm;
  };
}
