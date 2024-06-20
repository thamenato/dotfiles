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
}
