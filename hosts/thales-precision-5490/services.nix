{lib, ...}: {
  services = {
    hyprpaper.enable = lib.mkForce false;
  };
}
