{
  pkgs,
  backgrounds,
  lib,
  ...
}: let
  bg_laptop = "${backgrounds."wallhaven-kxo38d_1920x1080.png"}";
  swaybg = "${pkgs.swaybg}/bin/swaybg";
  bg_monitor = "${backgrounds."wallhaven-rrvygj_5120x1440.png"}";
  bg_command = "${swaybg} -m fill -o DP-2 -i ${bg_monitor} -o eDP-1 -i ${bg_laptop}";
in {
  stylix.image = bg_laptop;

  programs.niri = {
    settings = {
      spawn-at-startup = [
        {argv = ["1password"];}
        {argv = lib.strings.splitString " " bg_command;}
      ];

      outputs = {
        "DP-2" = {
          # monitor
          mode = {
            width = 5120;
            height = 1440;
            refresh = 120.000;
          };
          position = {
            x = 0;
            y = 0;
          };
        };
        "eDP-1" = {
          # laptop
          mode = {
            width = 1920;
            height = 1200;
            refresh = 60.026;
          };
          scale = 1;
          position = {
            x = 5120;
            y = 0;
          };
        };
      };
    };
  };
}
