{
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

    sessionVariables = {
      EDITOR = "nvim";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      OZONE_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
    };
  };

  fonts.fontconfig.enable = true;

  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
