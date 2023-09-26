{ config, pkgs, ... }:

{
  imports = [
    ./apps/alacritty.nix
    ./apps/git.nix
    ./apps/helix.nix
    ./apps/kitty.nix
    ./apps/zsh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thales";
  home.homeDirectory = "/home/thales";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # terminal
    pkgs.alacritty
    pkgs.kitty
    pkgs.direnv
    pkgs.fastfetch
    pkgs.httpie
    pkgs.fzf
    pkgs.macchina
    pkgs.ranger

    # dependencies
    pkgs.catppuccin-gtk
    pkgs.python311

    # browser
    pkgs.vivaldi
    pkgs.vivaldi-ffmpeg-codecs
    pkgs.google-chrome

    # editors/ide
    pkgs.helix
    pkgs.vscode
    pkgs.obsidian
    pkgs.jetbrains-toolbox
    pkgs.dbeaver

    # language servers
    pkgs.terraform-ls

    # apps
    pkgs.easyeffects
    pkgs.bitwarden
    pkgs.spotify
    pkgs.tidal-hifi
    pkgs.signal-desktop
    pkgs.slack

    # fonts
    (pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "Hack"
        "JetBrainsMono"
      ];
    })

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/thamenato/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.

  home.sessionVariables = {
    EDITOR = "hx";
  };

  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
