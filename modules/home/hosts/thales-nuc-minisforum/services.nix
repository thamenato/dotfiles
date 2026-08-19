# modules/home/hosts/thales-nuc-minisforum/services.nix
{...}: {
  flake.homeModules."hosts/thales-nuc-minisforum/services" = {config, ...}: {
    services = {
      # easyeffects.enable = lib.mkForce false;
      gnome-keyring = {
        enable = true;
        components = ["secrets"];
      };
      polkit-gnome.enable = true;
      swayidle.lockscreenCommand = "${config.programs.noctalia.package}/bin/noctalia msg session lock";
    };
  };
}
