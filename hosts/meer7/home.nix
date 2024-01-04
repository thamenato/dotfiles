{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home-manager/alacritty.nix
    ../../home-manager/git.nix
    ../../home-manager/helix.nix
    ../../home-manager/kitty.nix
    ../../home-manager/zsh.nix
    ../../home-manager/direnv.nix
    ../../home-manager/ripgrep.nix
  ];

  home.username = "thales";
  home.homeDirectory = "/home/thales";

  home.packages = with pkgs; [
    # terminal
    alejandra
    direnv
    fastfetch
    httpie
    fzf
    macchina
    ranger
    lazygit
    lazydocker
    zip
    unzip

    # dependencies/tools
    catppuccin-gtk

    # editors/ide
    vscode
    jetbrains-toolbox
    dbeaver

    # language servers
    terraform-ls
    nil
    yaml-language-server
    marksman

    # formatters
    dprint

    # apps
    spotify
    tidal-hifi
    signal-desktop
    slack

    # fonts
    (nerdfonts.override {
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
