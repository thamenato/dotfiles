{
  lib,
  pkgs,
  ...
}: let
  disabled = lib.mkForce false;
  enabled = lib.mkForce true;
in {
  programs = {
    alacritty.enable = disabled;
    go.enable = disabled;
    hyprlock.enable = disabled;
    kitty.enable = disabled;
    vscode.enable = enabled;
    waybar.enable = disabled;

    ghostty = {
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

    autorandr = {
      enable = true;

      # profiles = {
      #   # get the profiles first, with the command
      #   #     autorandr --fingerprint
      #   "office" = {
      #     fingerprint = {
      #       "eDP-1" = "00ffffffffffff004c2dca743747533027220103807722782aa515ab514aa7270f5054a54f8081c0810081809500a9c0b30001010101efdc0018f138404030203a00a8504100001a000000fd001e781eb73c000a202020202020000000fc004c53343943393578550a202020000000ff00484e54583930303337330a20200150020342f0e278024761103f04035f602309070783010000e2004fe305c0006b030c002000b8442000200167d85dc40178800be6060501605a1de20f41e5018b849001565e00a0a0a0295030203500a8504100001a6fc200a0a0a0555030203500a8504100001a1a6800a0f0381f4030203a00a8504100001a0000000000000064";
      #       "DP-1" = "00ffffffffffff0006af9af900000000141f0104a51e13780363f5a854489d240e505400000001010101010101010101010101010101fa3c80b870b0244010103e002dbc1000001ac83080b870b0244010103e002dbc1000001a000000fe004a38335646804231343055414e0000000000024101b2001100000a410a20200068";
      #     };
      #     config = {
      #       "eDP-1".enable = false;
      #       "DP-1" = {
      #         enable = true;
      #         primary = true;
      #         mode = "5120x1440";
      #         position = "0x0";
      #         rotate = "normal";
      #       };
      #     };
      #   };
      # };
    };
  };
}
