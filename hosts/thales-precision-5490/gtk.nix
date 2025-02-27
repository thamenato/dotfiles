{lib, ...}: {
  gtk = {
    gtk3.extraConfig = lib.mkForce {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
