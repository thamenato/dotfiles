{ config
, pkgs
, ...
}: {
  imports = [
    ../../home-manager/apps/alacritty.nix
    ../../home-manager/apps/direnv.nix
    ../../home-manager/apps/fzf.nix
    ../../home-manager/apps/git.nix
    ../../home-manager/apps/lazygit.nix
    ../../home-manager/apps/vscode.nix
    ../../home-manager/apps/zellij.nix
    ../../home-manager/apps/zoxide.nix
    ../../home-manager/apps/zsh.nix
  ];

  home.username = "thales";
  home.homeDirectory = "/Users/thales";

  home.packages = with pkgs; [
    # terminal
    httpie
    lazydocker
    nixpkgs-fmt
  ];

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
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
