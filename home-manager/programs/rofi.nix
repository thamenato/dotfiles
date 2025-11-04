{config, ...}: {
  programs.rofi = {
    enable = true;

    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      # https://man.archlinux.org/man/rofi-theme.5

      "entry" = {
        placeholder = "Search...";
      };

      "element" = {
        orientation = mkLiteral "horizontal";
        children = map mkLiteral ["element-icon" "element-text"];
        spacing = mkLiteral "15px";
      };

      "element-icon" = {
        size = mkLiteral "1.5em";
      };
    };
  };
}
