# modules/home/hosts/thales-nuc-minisforum/default.nix
{self, ...}: {
  flake.homeModules."hosts/thales-nuc-minisforum" = {...}: {
    imports = [
      self.homeModules."wayland/niri"
      self.homeModules."hosts/thales-nuc-minisforum/packages"
      self.homeModules."hosts/thales-nuc-minisforum/services"
      self.homeModules."hosts/thales-nuc-minisforum/programs"
    ];

    targets.genericLinux = {
      enable = true;
      gpu.enable = true;
    };

    home = {
      sessionVariables = {
        BROWSER = "zen-beta";
      };
    };
  };
}
