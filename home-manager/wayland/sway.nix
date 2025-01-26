{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.sway = let
    modifier = "Mod4";
    menu = "rofi -show drun | xargs swaymsg exec";
    terminal = "${pkgs.ghostty}/bin/ghostty";
  in {
    enable = false;
    wrapperFeatures.gtk = true;

    config = {
      inherit modifier;
      inherit terminal;
      inherit menu;

      keybindings = let
        grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save";
        satty = "${pkgs.satty}/bin/satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png";
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
        {command = "easyeffects --gapplication-service";}
        {command = "nm-applet --indicator";}
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
  };
}
