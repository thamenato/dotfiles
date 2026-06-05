# modules/home/programs/k9s/default.nix
{...}: {
  flake.homeModules."programs/k9s" = {...}: {
    programs.k9s = {
      enable = true;

      skins = {
        cyberdream = ./cyberdream.yml;
      };

      settings = {
        k9s = {
          skin = "cyberdream";
        };
      };
    };
  };
}
