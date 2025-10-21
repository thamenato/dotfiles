{pkgs, ...}: {
  imports = [
    ./dconf.nix
    ./gtk.nix
    ./packages.nix
    ./programs
    ./qt.nix
    ./services
    ./stylix.nix
    ./wayland
  ];

  home = {
    username = "thamenato";
    homeDirectory = "/home/thamenato";

    shellAliases = {
      lg = "lazygit";
      man = "batman";
    };

    file = {
      # ".config/niri/config.kdl".source = ./config/niri/config.kdl;
    };

    sessionVariables = {
      EDITOR = "nvim";
      NH_HOME_FLAKE = "$HOME/dotfiles";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      OZONE_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
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
