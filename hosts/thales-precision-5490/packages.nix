{
  config,
  pkgs,
  ...
}:
with pkgs; {
  home.packages = let
    satty-nixgl = config.lib.nixGL.wrap satty;
    signal-desktop-bin-nixgl = config.lib.nixGL.wrapOffload signal-desktop-bin;
    slack-nixgl = config.lib.nixGL.wrapOffload slack;
    xwayland-satellite-nixgl = config.lib.nixGL.wrap xwayland-satellite;
    zoom-us-nixgl = config.lib.nixGL.wrap zoom-us;
  in [
    _1password-cli
    _1password-gui
    devbox
    image-roll
    jiratui
    pwvucontrol
    satty-nixgl
    signal-desktop-bin-nixgl
    slack-nixgl
    slurp
    spotify
    uv
    xfce.thunar
    xwayland-satellite-nixgl
    zoom-us-nixgl
  ];
}
