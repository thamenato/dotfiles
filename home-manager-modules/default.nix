{ config
, pkgs
, ...
}: {
  imports = [
    ./appearance.nix
    ./apps/alacritty.nix
    ./apps/direnv.nix
    ./apps/eza.nix
    ./apps/fzf.nix
    ./apps/git.nix
    ./apps/lazygit.nix
    ./apps/neovim.nix
    ./apps/ripgrep.nix
    ./apps/rofi.nix
    ./apps/vscode.nix
    ./apps/zellij.nix
    ./apps/zoxide.nix
    ./apps/zsh.nix
    ./programming/go.nix
    # ./apps/hyprland.nix
    # ./apps/kitty.nix
  ];

  home.username = "thamenato";
  home.homeDirectory = "/home/thamenato";

  home.packages = with pkgs; [
    # terminal
    alejandra
    fastfetch
    httpie
    jq
    lazydocker
    nixpkgs-fmt
    unzip
    xxh
    zip

    # fonts
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
    ".gnupg/gpg-agent.conf".text = ''
      pinentry-program /run/current-system/sw/bin/pinentry
    '';
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
  home.stateVersion = "22.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
