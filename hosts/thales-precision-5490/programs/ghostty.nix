{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    package = config.lib.nixGL.wrap pkgs.ghostty;
    settings = {
      gtk-custom-css = let
        customCSS = pkgs.writeText "custom.css" ''
          window {
              padding: 0
          }
        '';
      in "${customCSS}";
    };
  };
}
