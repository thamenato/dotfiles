{pkgs, ...}: {
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
}
