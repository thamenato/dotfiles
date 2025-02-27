{
  pkgs,
  lib,
  config,
  ...
}: {
  xsession.windowManager.i3 = {
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
        };

      gaps = {
        smartBorders = "on";
        smartGaps = true;
        inner = 4;
        outer = -2;
      };

      assigns = {
        "2" = [{class = "^slack$";}];
      };

      floating = {
        criteria = [{class = "Pavucontrol";}];
      };

      window = {
        commands = [
          {
            # force border on ghostty, default doesn't work
            command = "border pixel 2";
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

      bars = [
        {
          mode = "dock";
          hiddenState = "hide";
          position = "top";
          workspaceButtons = true;
          workspaceNumbers = true;
          statusCommand = "${pkgs.i3status}/bin/i3status";
          fonts = {
            names = ["monospace"];
            size = 8.0;
          };
          trayOutput = "primary";
          colors = {
            background = "#000000";
            statusline = "#ffffff";
            separator = "#666666";
            focusedWorkspace = {
              border = "#4c7899";
              background = "#285577";
              text = "#ffffff";
            };
            activeWorkspace = {
              border = "#333333";
              background = "#5f676a";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              border = "#333333";
              background = "#222222";
              text = "#888888";
            };
            urgentWorkspace = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
            bindingMode = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
          };
        }
      ];

      startup = [
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
      ];
    };
  };
}
