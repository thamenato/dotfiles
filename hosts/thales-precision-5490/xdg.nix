{pkgs, ...}: {
  xdg = {
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
