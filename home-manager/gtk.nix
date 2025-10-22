{pkgs, ...}: {
  gtk = {
    enable = true;

    #
    # Cursors are being managed under `home.pointerCursors`
    # note to self: do not use `gtk.cursorTheme`
    #

    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };

    iconTheme = {
      package = pkgs.candy-icons;
      name = "candy-icons";
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
