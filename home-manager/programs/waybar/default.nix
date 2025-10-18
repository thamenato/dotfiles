{pkgs, ...}: {
  programs.waybar = {
    enable = true;

    settings = {
      main = {
        layer = "top";
        position = "top";
        height = 26;
        modules-left = [
          # "custom/hostname"
          "sway/workspaces"
          "niri/workspaces"
        ];
        modules-center = ["clock"];
        modules-right = [
          "disk"
          "temperature"
          "memory"
          "cpu"
          "battery"
          "pulseaudio"
          "tray"
          "custom/power"
        ];

        # modules
        "sway/workspaces" = {
        };
        "hyprland/workspaces" = {
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        clock = {
          format = "{:%Y-%m-%d %R}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          calendar-weeks-pos = "right";
          today-format = "<span color='#ff6699'><b><u>{}</u></b></span>";
          format-calendar = "<span color='#ecc6d9'><b>{}</b></span>";
          format-calendar-weeks = "<span color='#99ffdd'><b>W{:%V}</b></span>";
          format-calendar-weekdays = "<span color='#ffcc66'><b>{}</b></span>";
          on-scroll = {
            calendar = 1;
          };
        };

        disk = {
          interval = 30;
          format = " {percentage_used}%";
          path = "/";
        };

        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = " {temperatureC}°C";
          format = " {temperatureC}°C";
          interval = 2;
        };

        memory = {
          interval = 5;
          format = " {}%";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        cpu = {
          interval = 5;
          format = " {usage}%";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        pulseaudio = let
          pwvucontrol = "${pkgs.pwvucontrol}/bin/pwvucontrol";
          pactl = "${pkgs.pulseaudio}/bin/pactl";
        in {
          scroll-step = 1; # %, can be a float
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}  {format_source}";
          format-bluetooth-muted = " {icon}  {format_source}";
          format-muted = "婢 {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "וֹ";
            headset = "  ";
            phone = "";
            portable = "";
            car = "";
            default = [""];
          };
          on-click = "${pwvucontrol}";
          on-scroll-up = "${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
          on-scroll-down = "${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
        };

        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          max-length = 25;
        };

        tray = {
          icon-size = 18;
          spacing = 8;
        };

        "custom/power" = {
          format = "";
          tooltip = false;
          on-click = "exec ${./scripts/power-menu.sh}";
        };

        "custom/hostname" = {
          format = "{}";
          exec = "echo \${HOSTNAME^^}";
          interval = "once";
          tooltip = false;
        };

        "custom/weather" = {
          # to use the weather module replace <your_location> with your city or town
          # note: do not use spaces: new york would be newyork
          format = "{} °C";
          exec = "${pkgs.wttrbar}/bin/wttrbar --location Charlotte";
          return-type = "json";
          tooltip = true;
          interval = 3600;
        };
      };
    };
  };
}
