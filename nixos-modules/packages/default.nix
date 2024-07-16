{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    # tools/cli
    bat
    curl
    dig
    gnupg
    htop
    lf
    neovim
    pulseaudio
    unixtools.xxd
    wget

    # programming
    git
    python3
    rustup

    # terminal
    alacritty
    mako
    rofi

    # apps
    # bitwarden
    arandr
    darktable
    easyeffects
    pwvucontrol
    signal-desktop
    spotify
    vlc

    # browser
    brave
    firefox
  ];
}
