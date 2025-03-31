{
  pkgs,
  lib,
  config,
  ...
}: {
  xsession.windowManager.i3 = let
    background = ../../misc/backgrounds/wallhaven-rrvygj_5120x1440.png;
  in {
    enable = true;

    config = {
      modifier = "Mod4";

      defaultWorkspace = "workspace number 1";
      terminal = "ghostty"; # have to use it from snap store
      menu = "rofi -show drun -run-command \"i3-msg exec '{cmd}'\" -show-icons";

      keybindings = let
        inherit (config.xsession.windowManager.i3.config) modifier;
        pactl = "exec --no-startup-id pactl";
        refresh_i3status = "killall -SIGUSR1 i3status";
        maim = "exec --no-startup-id ${pkgs.maim}/bin/maim";
        xdotool = "${pkgs.xdotool}/bin/xdotool getactivewindow";
        ssOutput = "/home/$USER/Pictures/$(date -u +%Y-%m-%d_%H-%M-%S)-screenshot.jpg";
      in
        lib.mkOptionDefault {
          "${modifier}+Shift+q" = "kill";

          # lock screen (ctrl+alt+l)
          "Control+Mod1+l" = "exec ${pkgs.i3lock}/bin/i3lock -n -c 000000";

          # vim movement
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          # multimedia keys
          "XF86AudioRaiseVolume" = "${pactl} set-sink-volume @DEFAULT_SINK@ +10% && ${refresh_i3status}";
          "XF86AudioLowerVolume" = "${pactl} set-sink-volume @DEFAULT_SINK@ -10% && ${refresh_i3status}";
          "XF86AudioMute" = "${pactl} set-sink-mute @DEFAULT_SINK@ toggle && ${refresh_i3status}";
          "XF86AudioMicMute" = "${pactl} set-source-mute @DEFAULT_SOURCE@ toggle && ${refresh_i3status}";

          # monitor stuff bc X11 sucks
          "${modifier}+F12" = "exec --no-startup-id autorandr --change";

          # screenshot
          "Print" = "${maim} ${ssOutput}";
          "${modifier}+Print" = "${maim} --window $(${xdotool}) ${ssOutput}";
          "Shift+Print" = "${maim} --select ${ssOutput}";
        };

      gaps = {
        smartBorders = "on";
        smartGaps = true;
        inner = 4;
        outer = -2;
      };

      assigns = {
        "2" = [{class = "slack";}];
      };

      floating = {
        criteria = [
          {class = "Pavucontrol";}
          {class = "zoom";}
        ];
      };

      colors.focused = {
        background = "#285577";
        border = "#29c238";
        text = "#ffffff";
        indicator = "#2e9ef4";
        childBorder = "#29c238";
      };

      window = let
        borderSize = 2;
      in {
        border = borderSize;
        commands = [
          {
            # force border on ghostty, default doesn't work
            command = "border pixel ${toString borderSize}";
            criteria = {
              class = "ghostty";
            };
          }
        ];
      };

      modes = {
        resize = let
          size = "15 px";
        in {
          Escape = "mode default";
          Return = "mode default";
          # arrow
          Left = "resize shrink width ${size}";
          Down = "resize grow height ${size}";
          Up = "resize shrink height ${size}";
          Right = "resize grow width ${size}";
          # vim
          h = "resize shrink width ${size}";
          j = "resize grow height ${size}";
          k = "resize shrink height ${size}";
          l = "resize grow width ${size}";
        };
      };

      # disable bars, using services.polybar instead
      bars = [];

      startup = [
        {
          # define current window config
          command = "${pkgs.autorandr}/bin/autorandr --change";
          always = false;
          notification = false;
        }
        {
          # configure display power mgmt via xorg-xset
          # https://wiki.archlinux.org/title/Display_Power_Management_Signaling
          command = "xset s off";
          always = false;
          notification = false;
        }
        {
          # restart polybar if window size changed
          command = "systemctl --user restart polybar.service";
          always = false;
          notification = false;
        }
        {
          # NetworkManager is the most popular way to manage wireless networks on Linux,
          # and nm-applet is a desktop environment-independent system tray GUI for it.
          command = "nm-applet";
          always = false;
          notification = false;
        }
        {
          # Start XDG autostart .desktop files using dex.
          command = "dex --autostart --environment i3";
          always = false;
          notification = false;
        }
        {
          # dunst notification service
          command = "systemctl --user start dunst.service";
          always = false;
          notification = false;
        }
        {
          # audio tray applet
          command = "systemctl --user start pasystray.service";
          always = false;
          notification = false;
        }
        {
          # background
          command = "${pkgs.feh}/bin/feh --bg-scale ${background}";
          always = true;
          notification = false;
        }
      ];
    };
  };
}
