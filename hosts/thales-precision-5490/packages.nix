{pkgs, ...}:
with pkgs; {
  home.packages = [
    _1password-cli
    _1password-gui
    devbox
    image-roll
    jiratui
    pwvucontrol
    satty
    signal-desktop-bin
    slack
    slurp
    spotify
    uv
    xfce.thunar
    xwayland-satellite
    zoom-us
  ];
}
