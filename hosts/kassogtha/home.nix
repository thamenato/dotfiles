{ config, pkgs, ... }:

{
  imports = [
    ../../home-manager/alacritty.nix
    ../../home-manager/direnv.nix
    ../../home-manager/fzf.nix
    ../../home-manager/git.nix
    ../../home-manager/hyprland.nix
    ../../home-manager/lazygit.nix
    ../../home-manager/neovim.nix
    ../../home-manager/ripgrep.nix
    ../../home-manager/vscode.nix
    ../../home-manager/zoxide.nix
    ../../home-manager/zsh.nix
  ];

  home.username = "thamenato";
  home.homeDirectory = "/home/thamenato";

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.packages = with pkgs; [
    nixpkgs-fmt
  ];

  home.file = { };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.
}
