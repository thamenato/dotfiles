{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./dconf.nix
    ./gtk.nix
    ./i3.nix
    ./programs
    ./services
    # ./xdg.nix
  ];

  home = {
    sessionVariables = {
      GTK_THEME = "Sweet-Dark";
      BROWSER = "zen";
    };

    packages = with pkgs; [
      _1password-cli
      _1password-gui
      devbox
      gnome-tweaks
      nh
      signal-desktop
      slack
      spotify
    ];
  };

  targets.genericLinux.enable = true;
  wayland.windowManager.hyprland.enable = lib.mkForce false;
}
