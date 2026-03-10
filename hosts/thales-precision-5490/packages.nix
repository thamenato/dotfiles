{
  inputs,
  pkgs,
  ...
}: let
  flox = inputs.flox.packages.x86_64-linux.default;
in
  with pkgs; {
    home.packages = [
      # jiratui
      _1password-cli
      _1password-gui
      devbox
      flox
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
