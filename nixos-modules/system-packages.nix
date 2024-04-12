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

    # terminal
    alacritty
    kitty

    # apps
    bitwarden
    easyeffects
    signal-desktop
    spotify

    # browser
    brave
    firefox

    # theme
    catppuccin-gtk
  ];
}
