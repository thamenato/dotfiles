# modules/home/programs/btop.nix
{...}: {
  flake.homeModules."programs/btop" = {...}: {
    # app: btop
    # desc: resource monitor that shows usage and stats for processor, memory,
    #       disks, network and processes.
    # repo: https://github.com/aristocratos/btop
    programs.btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
  };
}
