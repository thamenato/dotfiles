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
    easyeffects
    signal-desktop

    # browser
    brave
    firefox
  ];
}
