{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.sway = let
    modifier = "Mod4";
    menu = "rofi -show drun -show-icons | xargs swaymsg exec --";
    terminal = "wezterm";
  in {
    enable = false;
    wrapperFeatures.gtk = true;

    config = {
      inherit modifier;
      inherit terminal;
      inherit menu;

      keybindings = let
        grimshot = "grimshot --notify save";
        satty = "satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
        pactl = "${pkgs.pulseaudio}/bin/pactl";
      in
        lib.mkOptionDefault {
          "print" = "exec ${grimshot} area - | ${satty}";
          "Shift+print" = "exec ${grimshot} output - | ${satty}";

          # resize floating windows with mouse scroll
          "--whole-window --border ${modifier}+button4" = "resize shrink height 5 px or 5 ppt";
          "--whole-window --border ${modifier}+button5" = "resize grow height 5 px or 5 ppt";
          "--whole-window --border ${modifier}+Shift+button4" = "resize shrink width 5 px or 5 ppt";
          "--whole-window --border ${modifier}+Shift+button5" = "resize grow width 5 px or 5 ppt";

          # multimedia audio keys
          "XF86AudioRaiseVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec ${pactl} set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec ${pactl} set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioPlay" = "exec ${playerctl} play";
          "XF86AudioPause" = "exec ${playerctl} pause";
          "XF86AudioNext" = "exec ${playerctl} next";
          "XF86AudioPrev" = "exec ${playerctl} previous";

          # backlight
          "XF86MonBrightnessUp" = "exec ${brightnessctl} -c backlight set +5%";
          "XF86MonBrightnessDown" = "exec ${brightnessctl} -c backlight set 5%-";

          # touchpad
          "XF86TouchpadToggle" = "input \"2321:21128:PNP0C50:0b_0911:5288_Touchpad\" events toggle enabled disabled";
        };

      keycodebindings = let
        playerctl = "${pkgs.playerctl}/bin/playerctl";
      in
        lib.mkOptionDefault {
          # Keychron Play/Pause button
          # xmodmap -pke | grep -i xf86audioplay
          "172" = "exec ${playerctl} play-pause";
        };

      startup = [
        {command = "nm-applet --indicator";}
        {command = "slack";}
        {command = "1password";}
        {command = "bitwarden";}
      ];

      window.commands = [
        {
          criteria = {
            app_id = "com.gabm.satty";
          };
          command = "floating enable";
        }
        {
          criteria = {
            app_id = "com.saivert.pwvucontrol";
          };
          command = "floating enable, resize set width 40 ppt height 30 ppt";
        }
      ];

      gaps = {
        smartGaps = true;
        inner = 4;
        outer = -2;
      };

      bars = [{command = "${pkgs.waybar}/bin/waybar";}];

      output = {
        # overwrite this per-host not here
        "*" = {
          # bg = "${background} fit";
        };
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "intl";
          xkb_options = "terminate:ctrl_alt_bksp";
          xkb_numlock = "enable";
        };

        "type:touchpad" = {
          events = "disabled_on_external_mouse";
          dwt = "enabled";
          middle_emulation = "enabled";
          natural_scroll = "enabled";
          tap = "enabled";
          drag = "enabled";
        };
      };
    };
    extraConfig = ''
      # only disable laptop monitor when external monitor is connected
      bindswitch --reload --locked lid:on exec "[ $(swaymsg -t get_outputs | jq '. | length') -gt 1 ] && swaymsg output eDP-1 disable"
      bindswitch --reload --locked lid:off output eDP-1 enable

      # xdg portal config
      exec systemctl --user set-environment XDG_CURRENT_DESKTOP=sway

      exec systemctl --user import-environment DISPLAY \
        SWAYSOCK \
        WAYLAND_DISPLAY \
        XDG_CURRENT_DESKTOP

      exec hash dbus-update-activation-environment 2>/dev/null && \
        dbus-update-activation-environment --systemd DISPLAY \
          SWAYSOCK \
          XDG_CURRENT_DESKTOP=sway \
          WAYLAND_DISPLAY
    '';
  };
}
