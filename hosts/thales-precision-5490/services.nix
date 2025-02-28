{
  lib,
  pkgs,
  ...
}: let
  disabled = lib.mkForce false;
  enabled = lib.mkForce true;
in {
  services = {
    hyprpaper.enable = disabled;
    easyeffects.enable = enabled;
    dunst = {
      # notification
      enable = true;

      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
        size = "16x16";
      };

      settings = {
        global = {
          width = 300;
          height = 300;
          offset = "30x50";
          origin = "top-right";
          transparency = 10;
          # frame_color = "#eceff1";
          frame_width = 2;
          font = "Hack 9";
        };

        urgency_normal = {
          # background = "#37474f";
          # foreground = "#eceff1";
          timeout = 15;
        };
      };
    };

    pasystray = {
      # sound tray
      enable = true;
    };

    polybar = {
      enable = true;
      package = pkgs.polybarFull;
      script = "polybar top &";

      settings = let
        background = "#99000000";
        foreground = "#ffdddddd";
      in {
        "bar/top" = {
          inherit background;
          inherit foreground;

          width = "100%";
          height = 24;
          radius = 0;

          line-size = 1;

          padding-left = 0;
          padding-right = 0;
          padding-top = 2;
          padding-bottom = 3;
          module-margin-left = 3;
          module-margin-right = 3;

          separator = "|";

          vertical-align = "center";

          fixed-center = true;

          font-0 = "Hack Nerd Font:size=9;0";

          modules-left = "i3";
          modules-center = "date";
          modules-right = "battery tray";

          wm-restack = "i3";
          # overline-size = 10;
          # underline-size = 2;
        };

        # "global/wm" = {
        #   margin-bottom = 0;
        #   margin-top = 2;
        # };

        # "settings" = {
        #   format-offset = 1;
        # };

        "module/date" = {
          type = "internal/date";
          interval = 5;
          date = "%Y-%m-%d";
          time = "%H:%M";
          label = "%date% %time%";
        };

        "module/i3" = let
          padding = 1;
        in {
          type = "internal/i3";
          format = "<label-state> <label-mode>";

          index-sort = true;
          show-urgent = true;
          pin-workspaces = true;

          label-mode = "%mode";
          label-mode-padding = padding;
          label-mode-foreground = foreground;
          label-mode-background = background;

          # focused = "Active workspace on focused monitor";
          label-focused = "%index%";
          label-focused-foreground = "#ffffff";
          label-focused-background = "#3f3f3f";
          lable-focused-underline = "#fba922";
          label-focused-padding = padding;

          # unfocused = "Inactive workspace on any monitor";
          label-unfocused = "%index%";
          label-unfocused-foreground = "#888888";
          label-unfocused-background = "#222222";
          label-unfocused-padding = padding;
          #
          # visible = "Active workspace on unfocused monitor";
          label-visible = "%index%";
          label-visible-underline = "#555555";
          label-visible-padding = padding;
          # label-visible-background = secondary;

          # urgent = "Workspace with urgency hint set";
          label-urgent = "%index%";
          label-urgent-foreground = "#ffffff";
          label-urgent-background = "#bd2c40";
          label-urgent-padding = padding;

          label-separator = " ";
          label-separator-padding = 0;
          # label-separator-foreground = "#666666";
        };

        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "AC";
          full-at = "98";

          format-charging = "<animation-charging> <label-charging>";

          format-discharging = "<ramp-capacity> <label-discharging>";

          format-full-prefix = " ";
          format-full-prefix-foreground = foreground;

          ramp-capacity-0 = "";
          ramp-capacity-1 = "";
          ramp-capacity-2 = "";
          ramp-capacity-foreground = foreground;

          animation-charging-0 = "";
          animation-charging-1 = "";
          animation-charging-foreground = foreground;
          animation-charging-framerate = "750";
        };

        "module/tray" = {
          type = "internal/tray";
          tray-padding = 5;
        };
      };
    };
  };
}
