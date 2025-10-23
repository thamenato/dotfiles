{
  config,
  lib,
  pkgs,
  ...
}: let
  disabled = lib.mkForce false;
in {
  imports = [
    ./niri.nix
    ./zen.nix
  ];

  programs = {
    go.enable = disabled;
    ncspot.package = pkgs.emptyDirectory;
    ghostty.package = config.lib.nixGL.wrapOffload pkgs.ghostty;
    git = {
      settings = {
        gpg.ssh.program = "op-ssh-sign";
      };
      signing = {
        key = lib.mkForce "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5BLR7Qc8IUUyRbdUY4YYKQOI8/vXaVaMkFKyUpBduP";
      };
    };
    swaylock = {
      enable = lib.mkForce true;
      package = null; # using swaylock from apt due to PAM issues
    };
  };
}
