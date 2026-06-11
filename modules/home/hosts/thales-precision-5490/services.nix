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

      # Handles DP-3 appearing after niri starts (5120x1440@144Hz link negotiation
      # can race with compositor startup). Kanshi listens for hotplug events and
      # re-applies the correct layout whenever an output comes or goes.
      kanshi = {
        enable = true;
        systemdTarget = "graphical-session.target";
        profiles = {
          dual.outputs = [
            {
              criteria = "Samsung Electric Company Odyssey G91SD HNTYC00800";
              mode = "5120x1440@143.987";
              position = "0,0";
            }
            {
              criteria = "AU Optronics 0xF99A Unknown";
              mode = "1920x1200@60.026";
              position = "5120,0";
              scale = 1.0;
            }
          ];
          laptop.outputs = [
            {
              criteria = "AU Optronics 0xF99A Unknown";
              mode = "1920x1200@60.026";
              position = "0,0";
              scale = 1.0;
            }
          ];
          external.outputs = [
            {
              criteria = "Samsung Electric Company Odyssey G91SD HNTYC00800";
              mode = "5120x1440@143.987";
              position = "0,0";
            }
          ];
        };
      };
    };
  };
}
