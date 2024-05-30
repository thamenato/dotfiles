{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    # tools/cli
    bat
    curl
    dig
    git
    gnupg
    htop
    lf
    neovim
    pinentry
    python3
    wget
    unixtools.xxd

    # terminal
    alacritty
    kitty

    # apps
    bitwarden
    easyeffects
    signal-desktop
    spotify
    vlc

    # browser
    brave
    firefox

    # theme
    catppuccin-gtk
  ];
}
