{ config
, pkgs
, ...
}: {
  imports = [
    ../../home-manager/apps/alacritty.nix
    ../../home-manager/apps/direnv.nix
    ../../home-manager/apps/fzf.nix
    ../../home-manager/apps/git.nix
    # ../../home-manager/apps/helix.nix
    ../../home-manager/apps/hyprland.nix
    # ../../home-manager/apps/kitty.nix
    ../../home-manager/apps/lazygit.nix
    ../../home-manager/apps/neovim.nix
    ../../home-manager/apps/ripgrep.nix
    ../../home-manager/apps/vscode.nix
    ../../home-manager/apps/zellij.nix
    ../../home-manager/apps/zoxide.nix
    ../../home-manager/apps/zsh.nix
  ];

  home.username = "thales";
  home.homeDirectory = "/home/thales";

  home.packages = with pkgs; [
    # terminal
    fastfetch
    httpie
    jq
    lazydocker
    unzip
    zip

    # dependencies/tools
    catppuccin-gtk
    python3
    python311Packages.pip

    # editors/ide
    dbeaver
    # jetbrains-toolbox

    # language servers
    terraform-ls
    nil
    yaml-language-server
    marksman

    # formatters
    dprint
    nixpkgs-fmt

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
