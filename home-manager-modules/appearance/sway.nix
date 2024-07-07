{ config, pkgs, wayland, lib, ... }:
let
  background = ../../misc/backgrounds/143952-abstract_art-color-blue-atmosphere-violet-2560x1440.jpg;
  modifier = "Mod4";
  menu = "wofi -I --show drun | xargs swaymsg exec";
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      modifier = modifier;
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = menu;

      # keybindings = lib.mkOptionDefault {
      #   "${modifier}+Shift+d" = drun";
      # };

      startup = [
        # { command = "vivaldi"; }
      ];

      output = {
        "*" = { bg = "${background} fit"; };
        # DP-1 = {
        #   resolution = "2560x1440";
        #   position = "0,1080";
        # };
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
}
