{ meta, pkgs, ... }:
{
  users = {
    users.${meta.user} = {
      isNormalUser = true;
      description = "Thales Menato";
      extraGroups = [
        "networkmanager"
        "wheel"
        "lp"
        "scanner"
      ];
    };
    extraGroups.docker.members = [ meta.user ];
    defaultUserShell = pkgs.zsh;
  };
}
