{lib, ...}: {
  services = {
    hyprpaper.enable = lib.mkForce false;
    gnome-keyring = {
      enable = true;
      components = ["secrets"];
    };
    polkit-gnome.enable = true;
  };
}
