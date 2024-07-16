{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;

    style = ./style.css;

    settings = {
      main = {
        layer = "top";
        position = "top";
        height = 28;
        modules-left = [
          "custom/hostname"
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [
          "clock"
          "custom/weather"
        ];
        modules-right = [
          "custom/spotify"
          "temperature"
          "memory"
          "cpu"
          "pulseaudio"
          "custom/grimshot"
          "idle_inhibitor"
          "tray"
          "custom/power"
        ];

        # modules
        "custom/hostname" = {
          format = "{}";
          exec = "echo \${HOSTNAME^^}";
          interval = 3600;
        };

        "sway/workspaces" = {
          disable-scroll = false;
          disable-markup = false;
          all-outputs = false;
          format = "{name}";
        };

        "sway/mode" = {
          format = "{}";
          tooltip = false;
        };

        "sway/window" = {
          format = "{}";
          max-length = 50;
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

        "clock" = {
          format = "{:%H:%M}  ";
          format-alt = "{:%A, %B %d, %Y (%R)}  ";
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

        "custom/spotify" = {
          interval = 1;
          return-type = "json";
          exec = "${./scripts/spotify.sh}";
          exec-if = "pgrep spotify";
          escape = true;
        };

        temperature = {
          # "thermal-zone": 1,
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = " {temperatureC}°C";
          format = " {temperatureC}°C";
          interval = 2;
        };

        memory = {
          interval = 5;
          format = " {}%";
          on-click = "xfce4-terminal -e 'htop'";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        cpu = {
          interval = 5;
          format = " {usage}% ({load})";
          states = {
            warning = 70;
            critical = 90;
          };
          on-click = "xfce4-terminal -e 'htop'";
        };

        pulseaudio = {
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
            default = [
              ""
            ];
          };
          on-click = "pwvucontrol";
          on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +2%";
          on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -2%";
        };

        "custom/grimshot" =
          let
            grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
          in
          {
            format = "";
            tooltip = false;
            on-click-right = "${grimshot} --notify save output - | swappy -f -";
            on-click-middle = "${grimshot} --notify save window - | swappy -f -";
            on-click = "${grimshot} --notify save area - | swappy -f -";
          };

        "idle_inhibitor" = {
          format = "{icon} ";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };

        "tray" = {
          icon-size = 18;
          spacing = 8;
        };

        "custom/power" = {
          format = "⏻";
          on-click = "exec ${./scripts/power-menu.sh}";
          tooltip = false;
        };

        "custom/separator" = {
          format = " ";
        };
      };
    };
  };
  home.packages = [ pkgs.playerctl ];
}
