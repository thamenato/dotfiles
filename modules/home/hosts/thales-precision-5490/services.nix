# modules/home/hosts/thales-precision-5490/services.nix
{...}: {
  flake.homeModules."hosts/thales-precision-5490/services" = {...}: {
    services = {
      # easyeffects.enable = lib.mkForce false;
      gnome-keyring = {
        enable = true;
        components = ["secrets"];
      };
      polkit-gnome.enable = true;
      swayidle.lockscreenCommand = "swaylock -fF";
    };
  };
}
