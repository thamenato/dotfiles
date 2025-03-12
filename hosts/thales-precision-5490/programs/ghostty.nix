{pkgs, ...}: {
  programs.ghostty = {
    package = null;
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
