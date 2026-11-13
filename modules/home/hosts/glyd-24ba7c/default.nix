# modules/home/hosts/glyd-24ba7c/default.nix
{self, ...}: {
  flake.homeModules."hosts/glyd-24ba7c" = {...}: {
    imports = [
      self.homeModules."wayland/niri"
      self.homeModules."programs/swaylock"
      self.homeModules."hosts/glyd-24ba7c/packages"
      self.homeModules."hosts/glyd-24ba7c/services"
      self.homeModules."hosts/glyd-24ba7c/programs"
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
