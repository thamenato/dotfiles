{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    _1password-cli
    _1password-gui
    devbox
    image-roll
    nh
    pwvucontrol
    (config.lib.nixGL.wrap satty)
    signal-desktop-bin
    # slack
    slurp
    # spotify
    sway-contrib.grimshot
    uv
    xfce.thunar
  ];
}
