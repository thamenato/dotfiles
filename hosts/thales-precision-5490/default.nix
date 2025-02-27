{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./dconf.nix
    ./gtk.nix
    ./i3.nix
    ./programs.nix
    ./services.nix
    ./xdg.nix
  ];

  home = {
    sessionVariables = {
      GTK_THEME = "Sweet-Dark";
    };

    packages = with pkgs; [
      _1password-cli
      _1password-gui
      devbox
      gnome-tweaks
      nh
      slack
    ];
  };

  targets.genericLinux.enable = true;
  wayland.windowManager.hyprland.enable = lib.mkForce false;
}
