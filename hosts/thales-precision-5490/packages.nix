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
    signal-desktop
    slack
    slurp
    spotify
    uv
    thunar
    xwayland-satellite
    zoom-us
  ];
}
