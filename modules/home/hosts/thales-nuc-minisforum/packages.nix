# modules/home/hosts/thales-nuc-minisforum/packages.nix
{...}: {
  flake.homeModules."hosts/thales-nuc-minisforum/packages" = {pkgs, ...}:
    with pkgs; {
      home.packages = [
        # jiratui
        _1password-cli
        _1password-gui
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
    };
}
