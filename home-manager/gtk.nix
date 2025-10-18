{pkgs, ...}: {
  gtk = {
    enable = true;

    #
    # Cursors are being managed under `home.pointerCursors`
    # note to self: do not use `gtk.cursorTheme`
    #

    iconTheme = {
      package = pkgs.candy-icons;
      name = "candy-icons";
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
}
