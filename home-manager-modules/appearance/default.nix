{ pkgs, ... }:
{
  imports = [
    ./rofi.nix
    ./sway.nix
    ./waybar
  ];

  home = {
    packages = with pkgs; [
      # themes
      flat-remix-gtk
      flat-remix-gnome
      flat-remix-icon-theme
    ];

    # pointerCursor = {
    #   gtk.enable = true;
    #   package = pkgs.bibata-cursors;
    #   name = "Bibata-Modern-Ice";
    #   size = 16;
    # };
  };

  gtk = {
    enable = true;

    theme = {
      # package = pkgs.adw-gtk3;
      # name = "adw-gtk3-dark";
      package = pkgs.sweet;
      name = "Sweet-Dark";
    };

    iconTheme = {
      # package = pkgs.flat-remix-gnome;
      # name = "Flat-Remix-Violet-Dark";
      package = pkgs.candy-icons;
      name = "candy-icons";
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };

    font = {
      name = "Hack Nerd Font";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
}
