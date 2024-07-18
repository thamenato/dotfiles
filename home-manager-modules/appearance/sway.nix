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
        in
        lib.mkOptionDefault
          {
            "print" = "exec ${grimshot} output";
            "Shift+print" = "exec ${grimshot} area";
          };

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
