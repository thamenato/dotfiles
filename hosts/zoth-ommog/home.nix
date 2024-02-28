{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home-manager/alacritty.nix
    ../../home-manager/direnv.nix
    ../../home-manager/fzf.nix
    ../../home-manager/git.nix
    ../../home-manager/hyprland.nix
    ../../home-manager/kitty.nix
    ../../home-manager/lazygit.nix
    ../../home-manager/neovim.nix
    ../../home-manager/ripgrep.nix
    ../../home-manager/vscode.nix
    ../../home-manager/zoxide.nix
    ../../home-manager/zsh.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thamenato";
  home.homeDirectory = "/home/thamenato";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # terminal
    direnv
    fastfetch
    httpie
    fzf
    macchina
    ranger
    lazygit
    lazydocker
    alejandra

    # dependencies
    catppuccin-gtk
    python3

    # browser
    firefox

    # editors/ide
    helix
    vscode

    # apps
    bitwarden
    spotify
    tidal-hifi
    signal-desktop
    slack

    # gaming
    xivlauncher
    discord

    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "Hack"
        "JetBrainsMono"
      ];
    })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
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
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
