{ pkgs, ... }:
{
  imports = [
    ./sway.nix
    ./rofi.nix
  ];

  home = {
    packages = with pkgs; [
      # themes
      flat-remix-gtk
      flat-remix-gnome
      flat-remix-icon-theme
    ];
    pointerCursor = {
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Dark";
    };

    iconTheme = {
      # package = pkgs.gnome.adwaita-icon-theme;
      # name = "Adwaita";
      package = pkgs.flat-remix-gnome;
      name = "Flat-Remix-Violet-Dark";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };
}
