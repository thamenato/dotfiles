# modules/home/hosts/thales-precision-5490/default.nix
{self, ...}: {
  flake.homeModules."hosts/thales-precision-5490" = {...}: {
    imports = [
      self.homeModules."wayland/niri"
      self.homeModules."programs/swaylock"
      self.homeModules."hosts/thales-precision-5490/packages"
      self.homeModules."hosts/thales-precision-5490/services"
      self.homeModules."hosts/thales-precision-5490/xdg"
      self.homeModules."hosts/thales-precision-5490/programs"
    ];

    targets.genericLinux = {
      enable = true;
      gpu.enable = true;
    };

    home = {
      sessionVariables = {
        BROWSER = "zen";
      };
    };
  };
}
