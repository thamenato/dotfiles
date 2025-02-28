{pkgs, ...}: {
  programs.ghostty = {
    package = null;
    settings = {
      ###########################
      # Neutron
      # Raycast_Dark
      # Monokai Soda
      # Mathias
      # GitHub-Dark-High-Contrast
      theme = "Neutron";
      ###########################
      gtk-custom-css = let
        customCSS = pkgs.writeText "custom.css" ''
          window {
              padding: 0
          }
        '';
      in "${customCSS}";

      background-opacity = 0.98;
    };
  };
}
