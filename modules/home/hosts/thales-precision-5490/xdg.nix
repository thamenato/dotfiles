# modules/home/hosts/thales-precision-5490/xdg.nix
{...}: {
  flake.homeModules."hosts/thales-precision-5490/xdg" = {pkgs, ...}: {
    xdg = {
      configFile = {
        "environment.d/envvars.conf".text = ''
          PATH="$HOME/.nix-profile/bin:$PATH"
        '';
      };

      portal = {
        enable = true;

        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
      };
    };
  };
}
