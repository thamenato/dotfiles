# Look for icons using https://www.nerdfonts.com/cheat-sheet
{pkgs, ...}: let
  pwvucontrol = "${pkgs.pwvucontrol}/bin/pwvucontrol";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
in {
  programs.waybar = {
    enable = true;

    style = builtins.readFile ./style.css;

    settings = {
      main = {
        layer = "top";
        position = "top";
        height = 26;

        # instantiate modules
        modules-left = [
          "clock"
          "disk"
          "temperature"
          "memory"
          "cpu"
          "custom/spotify"
        ];

        modules-center = [
          "niri/workspaces"
        ];

        modules-right = [
          "tray"
          "network"
          "wireplumber"
          "battery"
          "custom/power"
        ];

        # waybar module configuration
        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          max-length = 25;
        };

        clock = {
          format = " {:%A, %d %b %Y %H:%M}";
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

        cpu = {
          interval = 5;
          format = " {usage}%";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        disk = {
          interval = 30;
          format = " {percentage_used}%";
          path = "/";
        };

        memory = {
          interval = 5;
          format = " {}%";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        network = {
          format = "";
          format-ethernet = "󰈀 ";
          format-wifi = "{icon}";
          format-disconnected = "󰲛 ";
          format-icons = [
            "󰤯 "
            "󰤟 "
            "󰤢 "
            "󰤥 "
            "󰤨 "
          ];
          tooltip-format-wifi = "{essid}({signalStrength}%) {ipaddr}";
          tooltip-format-ethernet = "{ifname} {ipaddr}";
          tooltip-format-disconnected = "Disconnected";
          on-click = "nm-connection-editor";
        };

        "niri/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "active" = "";
            "default" = "";
          };
          icon-size = 10;
        };

        temperature = {
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = " {temperatureC}°C";
          format = " {temperatureC}°C";
          interval = 2;
        };

        tray = {
          icon-size = 16;
          spacing = 16;
        };

        wireplumber = {
          "format" = " {volume}%";
          "max-volume" = 100;
          "scroll-step" = 5;
          on-click = "${pwvucontrol}";
        };

        # my custom modules
        "custom/power" = {
          format = "";
          tooltip = false;
          on-click = "exec ${./scripts/power-menu.sh}";
        };

        "custom/spotify" = {
          format = " {text}";
          max-length = 40;
          interval = 5;
          exec = "${./scripts/spotify.sh}";
          exec-if = "pgrep spotify";
          return-type = "json";
          on-click = "${playerctl} -p spotify play-pause";
        };

        # deprecated modules - keeping it just in case
        pulseaudio = {
          scroll-step = 1; # %, can be a float
          format = "{icon} {volume}%";
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
      };
    };
  };
}
