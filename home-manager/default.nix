{pkgs, ...}: {
  imports = [
    ./gtk.nix
    ./packages.nix
    ./qt.nix
    ./services.nix
    ./programs
    ./services
    ./wayland
  ];

  home = {
    username = "thamenato";
    homeDirectory = "/home/thamenato";

    shellAliases = {
      nh-home = "nh home switch -a $HOME/dotfiles";
      nh-os = "nh os switch -a $HOME/Projects/nixos-hosts";
    };

    file = {
      ".gnupg/gpg-agent.conf".text = ''
        pinentry-program /run/current-system/sw/bin/pinentry
      '';
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
