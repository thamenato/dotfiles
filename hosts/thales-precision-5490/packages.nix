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
    (config.lib.nixGL.wrapOffload signal-desktop-bin)
    (config.lib.nixGL.wrapOffload slack)
    slurp
    spotify
    uv
    xfce.thunar
    (config.lib.nixGL.wrap zoom-us)
  ];
}
