{pkgs, ...}: {
  xdg = {
    configFile = {
      "environment.d/envvars.conf".text = ''
        PATH="$HOME/.nix-profile/bin:$PATH"
      '';
    };

    portal = {
      enable = true;

      config = {
        sway = {
          default = ["gtk"];
          "org.freedesktop.impl.portal.Screenshot" = ["gtk"];
          "org.freedesktop.impl.portal.ScreenCast" = ["gkt"];
        };
      };

      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };
}
