{pkgs, ...}: {
  imports = [
    ./gtk.nix
    ./packages.nix
    ./qt.nix
    ./services.nix
    ./programs
    ./services
    ./wayland
    ./modules/zen.nix
  ];

  home = {
    username = "thamenato";
    homeDirectory = "/home/thamenato";

    shellAliases = {
      lg = "lazygit";
      man = "batman";
    };

    file = {
      ".gnupg/gpg-agent.conf".text = ''
        pinentry-program /run/current-system/sw/bin/pinentry
      '';
      ".local/bin/nh-update" = {
        source = ../scripts/nh-update.sh;
        executable = true;
      };
    };

    sessionVariables = {
      EDITOR = "nvim";
    };

    pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;

      gtk.enable = true;
      hyprcursor = {
        enable = true;
        size = 24;
      };
    };
  };

  fonts.fontconfig.enable = true;

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
