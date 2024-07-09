{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    theme = "${pkgs.rofi}/share/rofi/themes/glue_pro_blue.rasi";
  };
}
