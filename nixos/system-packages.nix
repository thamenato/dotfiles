{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # tools/cli
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

    # terminal
    ghostty
    mako
    networkmanagerapplet
    rofi

    # apps
    arandr
    calibre
    easyeffects
    evince
    onlyoffice-desktopeditors
    pwvucontrol
    signal-desktop
    simple-scan
    slack
    spotify
    ventoy
    vlc
    xfce.thunar
    # xwaylandvideobridge
    yubikey-manager

    # browser
    firefox
    google-chrome

    # hyprland dependencies
    hyprpolkitagent
  ];
}
