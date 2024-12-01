{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # tools/cli
    bat
    bitwarden-cli
    cachix
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
    networkmanagerapplet
    rofi

    # apps
    arandr
    calibre
    darktable
    easyeffects
    pwvucontrol
    signal-desktop
    simple-scan
    spotify
    ventoy
    vlc
    xfce.thunar
    xwaylandvideobridge
    yubikey-manager

    # browser
    firefox
  ];
}
