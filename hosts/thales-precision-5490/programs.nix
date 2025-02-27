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

    starship.settings.format = lib.concatStrings [
      "$username"
      "$hostname"
      "$directory"
      "$git_branch"
      "$git_commit"
      "$git_state"
      "$git_metrics"
      "$git_status"
    ];

    autorandr = let
      fp_DP-1 = "00ffffffffffff004c2dc5743747533027220104b57722783aa515ab514aa7270f5054a54f8081c0810081809500a9c0b300010101011a6800a0f0381f4030203a00a8504100001a000000fd0032781eb742000a202020202020000000fc004c53343943393578550a202020000000ff00484e54583930303337330a202002d7020323f04561103f04032309070783010000e305c000e6060501605a1de5018b849001565e00a0a0a0295030203500a8504100001a6fc200a0a0a0555030203500a8504100001ae77c70a0d0a0295030203a00a8504100001a00000000000000000000000000000000000000000000000000000000000000000000000000008b701279030003013cf8bd0088ff133f012f801f009f05310002000900520101086f0d9f002f801f009f0553000200070073d60008ff0e9f002f801f0037043f0002000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006090";
      fp_eDP-1 = "00ffffffffffff0006af9af900000000141f0104a51e13780363f5a854489d240e505400000001010101010101010101010101010101fa3c80b870b0244010103e002dbc1000001ac83080b870b0244010103e002dbc1000001a000000fe004a38335646804231343055414e0000000000024101b2001100000a410a20200068";
    in {
      enable = true;

      profiles = {
        "office" = {
          fingerprint = {
            "DP-1" = fp_DP-1;
          };
          config = {
            "eDP-1".enable = false;
            "DP-2".enable = false;
            "DP-3".enable = false;
            "DP-4".enable = false;
            "DP-1" = {
              enable = true;
              crtc = 0;
              mode = "5120x1440";
              position = "0x0";
              primary = true;
              rate = "60.00";
            };
          };
        };
        "laptop" = {
          fingerprint = {
            "eDP-1" = fp_eDP-1;
          };
          config = {
            "eDP-1" = {
              enable = true;
              crtc = 0;
              mode = "1920x1200";
              position = "0x0";
              primary = true;
              rate = "60.03";
            };
            "DP-1".enable = false;
            "DP-2".enable = false;
            "DP-3".enable = false;
            "DP-4".enable = false;
          };
        };
        "both" = {
          fingerprint = {
            "DP-1" = fp_DP-1;
            "eDP-1" = fp_eDP-1;
          };
          config = {
            "eDP-1" = {
              enable = true;
              crtc = 1;
              mode = "1920x1200";
              position = "5120x240";
              primary = false;
              rate = "60.03";
            };
            "DP-1" = {
              enable = true;
              crtc = 0;
              mode = "5120x1440";
              position = "0x0";
              primary = true;
              rate = "60.00";
            };
            "DP-2".enable = false;
            "DP-3".enable = false;
            "DP-4".enable = false;
          };
        };
      };
    };
  };
}
