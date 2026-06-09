# modules/home/programs/noctalia.nix
{...}: {
  flake.homeModules."programs/noctalia" = {...}: {
    programs.noctalia = {
      enable = true;

      settings = {
        bar = {
          density = "compact";
          position = "top";
          showCapsule = false;
          widgets = {
            left = [
              {
                formatHorizontal = "yyyy-MM-dd HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
              {
                id = "SystemMonitor";
              }
              {
                id = "MediaMini";
              }
              {
                id = "Tailscale";
              }
            ];
            center = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
            ];
            right = [
              {
                id = "Tray";
              }
              {
                id = "WiFi";
              }
              {
                id = "Bluetooth";
              }
              {
                alwaysShowPercentage = true;
                id = "Battery";
                warningThreshold = 30;
              }
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
            ];
          };
        };
        colorSchemes.predefinedScheme = "Monochrome";
        general = {
          avatarImage = "/home/drfoobar/.face";
          radiusRatio = 0.2;
        };
        location = {
          monthBeforeDay = true;
          name = "Charlotte, NC";
        };
      };
    };
  };
}
