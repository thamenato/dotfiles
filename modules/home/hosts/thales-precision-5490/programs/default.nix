# modules/home/hosts/thales-precision-5490/programs/default.nix
{self, ...}: {
  flake.homeModules."hosts/thales-precision-5490/programs" = {
    lib,
    pkgs,
    inputs,
    ...
  }: let
    disabled = lib.mkForce false;

    # Patch noctalia to use "noctalia" as PAM service name instead of "login".
    # On Ubuntu (non-NixOS), nix's libpam can't parse /etc/pam.d/login (@include syntax),
    # so we point it at /etc/pam.d/noctalia which uses absolute paths to system modules.
    patchedNoctalia = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          substituteInPlace src/auth/pam_authenticator.cpp \
            --replace-fail 'pam_start("login"' 'pam_start("noctalia"'
        '';
    });
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
      noctalia.package = lib.mkForce patchedNoctalia;
    };
  };
}
