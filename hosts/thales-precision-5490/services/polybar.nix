{pkgs, ...}: {
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    script = ''
      polybar top &
    '';

    settings = let
      colors = {
        "bg" = "#151515";
        "bg-alt" = "#232323";
        "bg-darker" = "#151515";
        "fg" = "#ffffff";
        "fg-alt" = "#474747";

        "blue" = "#2979ff";
        "cyan" = "#00e5ff";
        "green" = "#00e676";
        "orange" = "#ff9100";
        "pink" = "#f50057";
        "purple" = "#d500f9";
        "red" = "#ff1744";
        "yellow" = "#ffea00";

        "black" = "#000";
        "white" = "#FFF";

        "trans" = "#00000000";
        "semi-trans-black" = "#aa000000";
      };
    in {
      "settings" = {
        screenchange-reload = true;
        # pseudo-transparency = true;
      };

      "bar/top" = {
        fixed-center = true;
        bottom = false;

        width = "100%";
        height = 24;

        override-redirect = false;

        scroll-up = "next";
        scroll-down = "prev";

        enable-ipc = true;

        background = colors.bg;
        foreground = colors.fg;

        module-margin-left = 2;
        module-margin-right = 2;

        # separator = "|";
        # separator-foreground = colorGray;

        font-0 = "Iosevka Nerd Font:size=9;0";

        modules-left = "i3";
        modules-center = "date";
        modules-right = "battery tray";
      };

      "module/i3" = let
        padding = 1;
        label = "%{T2}%index%%{T-}";
      in {
        type = "internal/i3";

        index-sort = true;
        show-urgent = true;

        label-mode = "%mode";
        label-mode-padding = padding;
        label-mode-foreground = colors.fg;

        # focused = "Active workspace on focused monitor";
        label-focused = label;
        label-focused-foreground = colors.fg;
        label-focused-padding = padding;

        # unfocused = "Inactive workspace on any monitor";
        label-unfocused = label;
        label-unfocused-foreground = colors.fg-alt;
        label-unfocused-padding = padding;

        # urgent = "Workspace with urgency hint set";
        label-urgent = label;
        label-urgent-foreground = colors.red;
        label-urgent-padding = padding;
      };

      "module/date" = {
        type = "internal/date";
        interval = 5;

        date = "%Y-%m-%d";
        time = "%H:%M";

        format = "<label>";
        format-padding = 1;

        label = "%date% %time%";
        label-padding = 1;
      };

      "module/battery" = {
        type = "internal/battery";

        battery = "BAT0";
        adapter = "AC";
        full-at = "98";

        format-charging = "<animation-charging> <label-charging>";
        format-charging-padding = 1;

        format-discharging = "<ramp-capacity> <label-discharging>";

        format-full-prefix = " ";
        format-full-prefix-foreground = colors.fg-alt;

        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-foreground = colors.fg-alt;

        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-foreground = colors.fg-alt;
        animation-charging-framerate = "750";
      };

      "module/tray" = {
        type = "internal/tray";

        tray-padding = 4;
        tray-maxsize = 16;
        tray-background = colors.bg;
      };
    };
  };
}
