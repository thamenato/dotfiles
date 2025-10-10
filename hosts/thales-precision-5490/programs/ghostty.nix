{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    package = config.lib.nixGL.wrapOffload pkgs.ghostty;
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
