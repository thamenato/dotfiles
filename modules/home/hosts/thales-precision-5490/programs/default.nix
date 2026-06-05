# modules/home/hosts/thales-precision-5490/programs/default.nix
{self, ...}: {
  flake.homeModules."hosts/thales-precision-5490/programs" = {
    lib,
    pkgs,
    ...
  }: let
    disabled = lib.mkForce false;
  in {
    imports = [
      self.homeModules."hosts/thales-precision-5490/programs/niri"
      self.homeModules."hosts/thales-precision-5490/programs/zen"
    ];

    programs = {
      go.enable = disabled;
      ncspot.package = pkgs.emptyDirectory;
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
  };
}
