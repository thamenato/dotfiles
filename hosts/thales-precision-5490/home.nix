{
  pkgs,
  lib,
  ...
}: let
  disabled = lib.mkForce false;
  enabled = lib.mkForce true;
in {
  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    nh
    slack
    _1password-gui
    _1password-cli
  ];

  programs = {
    alacritty.enable = disabled;
    ghostty.enable = disabled;
    go.enable = disabled;
    hyprlock.enable = disabled;
    kitty.enable = enabled;
    rofi.enable = disabled;
    # vscode.enable = enabled;
    waybar.enable = disabled;
    gnome-shell = {
      enable = true;
      theme = {
        name = "Plata-Noir";
        package = pkgs.plata-theme;
      };
      extensions = [
        {package = pkgs.gnomeExtensions.tailscale-status;}
      ];
    };
  };

  services = {
    hyprpaper.enable = disabled;
  };

  wayland.windowManager.hyprland.enable = disabled;
}
