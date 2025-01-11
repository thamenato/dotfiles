{
  imports = [
    ./gtk.nix
    ./packages.nix
    ./services.nix
    ./xdg.nix
    ./programs
    ./wayland
  ];

  home.username = "thamenato";
  home.homeDirectory = "/home/thamenato";

  home.file = {
    ".gnupg/gpg-agent.conf".text = ''
      pinentry-program /run/current-system/sw/bin/pinentry
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  fonts.fontconfig.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
