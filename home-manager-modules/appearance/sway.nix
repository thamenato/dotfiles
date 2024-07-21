{ config, pkgs, wayland, lib, ... }:
let
  background = ../../misc/backgrounds/143952-abstract_art-color-blue-atmosphere-violet-2560x1440.jpg;
  modifier = "Mod4";
  menu = "rofi -show drun | xargs swaymsg exec";
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      modifier = modifier;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = menu;

      keybindings =
        let
          grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save";
          playerctl = "${pkgs.playerctl}/bin/playerctl";
          brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
          pactl = "${pkgs.pulseaudio}/bin/pactl";
        in
        lib.mkOptionDefault
          {
            "print" = "exec ${grimshot} output";
            "Shift+print" = "exec ${grimshot} area";

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
          };

      keycodebindings =
        let
          playerctl = "${pkgs.playerctl}/bin/playerctl";
        in
        lib.mkOptionDefault
          {
            # Keychron Play/Pause button
            # xmodmap -pke | grep -i xf86audioplay
            "172" = "exec ${playerctl} play-pause";
          };

      startup = [
        { command = "easyeffects --gapplication-service"; }
      ];

      window.commands = [
        {
          criteria = { app_id = "com.gabm.satty"; };
          command = "floating enable";
        }
        {
          criteria = { app_id = "com.saivert.pwvucontrol"; };
          command = "floating enable, resize set width 40 ppt height 30 ppt";
        }
      ];

      gaps = {
        smartGaps = true;
        inner = 4;
        outer = -2;
      };

      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
      }];

      output = {
        "*" = { bg = "${background} fit"; };
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us";
          xkb_variant = "intl";
          xkb_options = "terminate:ctrl_alt_bksp";
          xkb_numlock = "enable";
        };

        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };
    };
  };

  programs.swaylock.settings = {
    image = "${background}";
    indicator-caps-lock = true;
    indicator-radius = 115;
    inside-color = "#2e344098";
    inside-ver-color = "#5e81ac";
    key-hl-color = "#5e81ac";
    layout-text-color = "#eceff4";
    line-color = "#3b4252";
    line-ver-color = "#5e81ac";
    line-wrong-color = "#d08770";
    ring-color = "#4c566a";
    ring-ver-color = "#5e81ac98";
    separator-color = "#4c566a";
    text-color = "#d8dee9";
  };
}
