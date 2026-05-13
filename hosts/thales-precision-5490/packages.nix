{pkgs, ...}:
with pkgs; {
  home.packages = [
    # jiratui
    _1password-cli
    _1password-gui
    devbox
    image-roll
    pwvucontrol
    satty
    signal-desktop
    slack
    slurp
    spotify
    thunar
    uv
    xwayland-satellite
    zoom-us
  ];
}
