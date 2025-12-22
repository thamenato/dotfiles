{lib, ...}: {
  services = {
    easyeffects.enable = lib.mkForce false;
    gnome-keyring = {
      enable = true;
      components = ["secrets"];
    };
    polkit-gnome.enable = true;
    swayidle.lockscreenCommand = "swaylock -fF";
  };
}
