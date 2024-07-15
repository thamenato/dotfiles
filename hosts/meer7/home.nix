{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ../../home-manager-modules
  ];

  home.username = lib.mkForce "thales";
  home.homeDirectory = lib.mkForce "/home/thales";

  home.packages = with pkgs; [
    # dependencies/tools
    devenv
    python3
    python311Packages.pip
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/xxh/config.xxhc".text = ''
      hosts:
        ".*":
          +s: zsh
    '';
  };

  wayland.windowManager.sway.config.output =
    let
      ultrawide_bg = ../../misc/backgrounds/wallhaven-vql78p_3840x1600.png;
    in
    {
      # main
      DP-3 = {
        position = "0,580";
        bg = "${ultrawide_bg} fit";
        res = "3840x1600";
      };
      # right bottom
      HDMI-A-1 = {
        position = "3840,1080";
        res = "1920x1080";
      };
      # right top
      HDMI-A-2 = {
        position = "3840,0";
        res = "1920x1080";
      };
    };
}
