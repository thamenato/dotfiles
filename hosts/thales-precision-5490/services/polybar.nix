{pkgs, ...}: {
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    script = ''
      polybar top &
    '';

    settings = let
      background = "#99000000";
      foreground = "#ffdddddd";
      colorGray = "#888888";
      colorRed = "#a8323a";
    in {
      "bar/top" = {
        inherit background;
        inherit foreground;

        enable-ipc = true;
        bottom = false;
        fixed-center = true;
        height = 24;

        module-margin-left = 2;
        module-margin-right = 2;

        separator = "|";
        separator-foreground = colorGray;

        font-0 = "Hack Nerd Font:size=9;0";

        modules-left = "i3";
        modules-center = "date";
        modules-right = "battery tray";
      };

      "module/i3" = let
        padding = 1;
        label = "%index%";
      in {
        type = "internal/i3";

        index-sort = true;
        show-urgent = true;

        # focused = "Active workspace on focused monitor";
        label-focused = label;
        label-focused-foreground = foreground;
        label-focused-padding = padding;

        # unfocused = "Inactive workspace on any monitor";
        label-unfocused = label;
        label-unfocused-foreground = colorGray;
        label-unfocused-padding = padding;

        # urgent = "Workspace with urgency hint set";
        label-urgent = label;
        label-urgent-foreground = colorRed;
        label-urgent-padding = padding;
      };

      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "%Y-%m-%d";
        time = "%H:%M";
        label = "%date% %time%";
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
}
