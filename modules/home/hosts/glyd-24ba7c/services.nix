# modules/home/hosts/glyd-24ba7c/services.nix
{...}: {
  flake.homeModules."hosts/glyd-24ba7c/services" = {...}: {
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
        settings = [
          {
            profile.name = "dual";
            profile.outputs = [
              {
                criteria = "Samsung Electric Company Odyssey G91SD HNTYC00800";
                mode = "5120x1440@143.987";
                position = "0,0";
              }
              {
                criteria = "eDP-1";
                mode = "2560x1600@90";
                position = "5120,0";
                scale = 1.6;
              }
            ];
          }
          {
            # ThinkPad P14s Gen 6 panel: AUO B145QAN01.K, 2560x1600@90, scale 1.6 -> 1600x1000 logical.
            # Portable display on DP-3, laptop on the left.
            # Must stay after "dual" (Samsung is also DP-3).
            profile.name = "portable";
            profile.outputs = [
              {
                criteria = "eDP-1";
                mode = "2560x1600@90";
                position = "0,0";
                scale = 1.6;
              }
              {
                criteria = "DP-3";
                mode = "1920x1080@60.000";
                position = "1600,0";
              }
            ];
          }
          {
            profile.name = "laptop";
            profile.outputs = [
              {
                criteria = "eDP-1";
                mode = "2560x1600@90";
                position = "0,0";
                scale = 1.6;
              }
            ];
          }
          {
            profile.name = "external";
            profile.outputs = [
              {
                criteria = "Samsung Electric Company Odyssey G91SD HNTYC00800";
                mode = "5120x1440@143.987";
                position = "0,0";
              }
            ];
          }
        ];
      };
    };
  };
}
