# Reference docs: https://github.com/sodiboo/niri-flake/blob/main/docs.md
{config, ...}: {
  programs.niri = {
    enable = true;
    settings = {
      prefer-no-csd = true;
      hotkey-overlay = {
        skip-at-startup = true;
      };

      input = {
        # Focus windows and outputs automatically when moving the mouse into them.
        # Setting max-scroll-amount="0%" makes it work only on windows already fully on screen.
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "0%";
        };
      };

      # outputs defined directly per host
      outputs = {};

      layout = {
        gaps = 8;
        default-column-width = {};
        center-focused-column = "never";
        background-color = "transparent";
        preset-column-widths = [
          {proportion = 1. / 3.;}
          {proportion = 1. / 2.;}
          {proportion = 2. / 3.;}
        ];
        default-column-width = {
          proportion = 1. / 2.;
        };
        focus-ring = {
          width = 4;
        };
        border = {
          enable = false;
        };
        shadow = {
          enable = false;
        };
        struts = {
          left = 0;
          right = 0;
          top = 0;
          bottom = 0;
        };
      };

      animations = {
        enable = true;
      };

      window-rules = [
        {
          # do not draw solid background when drawing a border this is
          # required for applications with transparent backgrounds
          draw-border-with-background = false;
        }
        {
          # block certain windows from showing up when sharing screen
          matches = [
            {app-id = "1Password";}
            {app-id = "Bitwarden";}
          ];
          block-out-from = "screencast";
        }
        {
          # show a border in windows that are currently being shared
          matches = [
            {
              is-window-cast-target = true;
            }
          ];
          focus-ring = {
            active.color = "#f38ba8";
            inactive.color = "#f38ba8";
          };
          border = {
            enable = true;
            inactive.color = "#f38ba8";
          };
          tab-indicator = {
            active.color = "#f38ba8";
            inactive.color = "#7d0d2d";
          };
        }
      ];

      cursor = {
        theme = "default";
        size = 24;
      };

      spawn-at-startup = [
        {argv = ["waybar"];}
      ];

      binds = with config.lib.niri.actions; {
        # show a list of important hotkeys
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        # main binds
        "Mod+Return" = {
          action = spawn "ghostty";
          hotkey-overlay.title = "Open a Terminal: ghostty";
        };
        "Mod+Shift+E" = {
          action = quit;
          hotkey-overlay.title = "Exit niri";
        };
        "Mod+D" = {
          action = spawn-sh "rofi -show drun -show-icons";
          hotkey-overlay.title = "Run an Application: rofi";
        };
        "Ctrl+Alt+L" = {
          action = spawn "swaylock";
          hotkey-overlay.title = "Lock the Screen: swaylock";
        };
        "Mod+Shift+P" = {
          action = power-off-monitors;
          hotkey-overlay.title = "Turn off monitors";
        };

        # window management
        "Mod+O" = {
          repeat = false;
          action = toggle-overview;
        };

        "Mod+Shift+Q" = {
          action = close-window;
          repeat = false;
        };

        "Mod+V".action = toggle-window-floating;
        "Mod+W".action = toggle-column-tabbed-display;

        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;
        "Mod+L".action = focus-column-right;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
        "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
        "Mod+Shift+L".action = move-column-right;

        "Mod+WheelScrollDown" = {
          action = focus-workspace-down;
          cooldown-ms = 150;
        };
        "Mod+WheelScrollUp" = {
          action = focus-workspace-up;
          cooldown-ms = 150;
        };
        "Mod+Ctrl+WheelScrollDown" = {
          action = move-column-to-workspace-down;
          cooldown-ms = 150;
        };
        "Mod+Ctrl+WheelScrollUp" = {
          action = move-column-to-workspace-up;
          cooldown-ms = 150;
        };

        # multimedia keys
        "XF86AudioRaiseVolume" = {
          action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action = spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          allow-when-locked = true;
        };
        "XF86AudioMute" = {
          action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          allow-when-locked = true;
        };
        "XF86AudioMicMute" = {
          action = spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          allow-when-locked = true;
        };
        "XF86MonBrightnessUp" = {
          action = spawn "brightnessctl" "--class=backlight" "set" "+10%";
          allow-when-locked = true;
        };
        "XF86MonBrightnessDown" = {
          action = spawn "brightnessctl" "--class=backlight" "set" "10%-";
          allow-when-locked = true;
        };

        # screenshot
        "Print".action = screenshot;
        # "Ctrl+Print".action = screenshot-screen;
        "Alt+Print".action = screenshot-window;

        # workspaces
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;

        "Mod+Ctrl+1".action = move-column-to-index 1;
        "Mod+Ctrl+2".action = move-column-to-index 2;
        "Mod+Ctrl+3".action = move-column-to-index 3;
        "Mod+Ctrl+4".action = move-column-to-index 4;
        "Mod+Ctrl+5".action = move-column-to-index 5;
        "Mod+Ctrl+6".action = move-column-to-index 6;
        "Mod+Ctrl+7".action = move-column-to-index 7;
        "Mod+Ctrl+8".action = move-column-to-index 8;
        "Mod+Ctrl+9".action = move-column-to-index 9;

        "Mod+Tab".action = focus-workspace-previous;
      };
    };
  };
}
