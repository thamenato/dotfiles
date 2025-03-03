{lib, ...}: let
  disabled = lib.mkForce false;
  enabled = lib.mkForce true;
in {
  imports = [
    ./dunst.nix
    ./polybar.nix
  ];

  services = {
    hyprpaper.enable = disabled;
    easyeffects.enable = enabled;

    pasystray = {
      # sound tray
      enable = true;
    };
  };
}
