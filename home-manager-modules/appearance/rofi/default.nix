{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    theme = ./catppuccin-frappe.rasi;

    # To select one of the built-in themes:
    # theme = "${pkgs.rofi}/share/rofi/themes/glue_pro_blue.rasi";
  };
}
