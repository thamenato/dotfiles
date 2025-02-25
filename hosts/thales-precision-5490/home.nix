{
  pkgs,
  lib,
  ...
}: let
  disabled = lib.mkForce false;
  enabled = lib.mkForce true;
in {
  targets.genericLinux.enable = true;

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

  xdg = {
    # fixes Nautilus crashing when .js or .json file in a folder
    # https://gitlab.gnome.org/GNOME/nautilus/-/issues/3273
    mime.enable = false;

    portal = {
      enable = true;

      config = {
        "*" = {
          default = ["gtk"];
        };
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
  };

  programs = {
    alacritty.enable = disabled;
    go.enable = disabled;
    hyprlock.enable = disabled;
    kitty.enable = disabled;
    rofi.enable = disabled;
    vscode.enable = enabled;
    waybar.enable = disabled;

    ghostty = {
      package = null;
      settings = {
        ###########################
        # Neutron
        # Raycast_Dark
        # Monokai Soda
        # Mathias
        # GitHub-Dark-High-Contrast
        theme = "Neutron";
        ###########################

        window-decoration = lib.mkForce true;
        background-opacity = 0.98;
      };
    };
  };

  services = {
    hyprpaper.enable = disabled;
    easyeffects.enable = enabled;
  };

  gtk = {
    gtk3.extraConfig = lib.mkForce {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Sweet-Dark";
    };
  };

  wayland.windowManager.hyprland.enable = disabled;
}
