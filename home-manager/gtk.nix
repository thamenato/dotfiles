{pkgs, ...}: {
  gtk = {
    enable = true;

    #
    # Cursors are being managed under `home.pointerCursors`
    # note to self: do not use `gtk.cursorTheme`
    #

    # theme = {
    #   package = pkgs.sweet;
    #   name = "Sweet-Dark";
    # };

    iconTheme = {
      package = pkgs.candy-icons;
      name = "candy-icons";
    };

    # font = {
    #   name = "Iosevka NF";
    #   size = 11;
    # };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
}
