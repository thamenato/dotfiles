{ config, pkgs, ...}:
{
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
}

