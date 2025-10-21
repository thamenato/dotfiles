{
  services = {
    gnome-keyring = {
      enable = true;
      components = ["secrets"];
    };
    polkit-gnome.enable = true;
  };
}
