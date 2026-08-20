# modules/home/hosts/thales-precision-5490/programs/default.nix
{self, ...}: {
  flake.homeModules."hosts/thales-precision-5490/programs" = {
    backgrounds,
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
            --replace-fail 'pam_start(service.data()' 'pam_start("noctalia"'
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
      noctalia = {
        package = lib.mkForce patchedNoctalia;
        settings = {
          wallpaper = {
            default.path = "${backgrounds."wallhaven-rrvygj_5120x1440.png"}";
            monitors = {
              "DP-3".path = "${backgrounds."wallhaven-rrvygj_5120x1440.png"}";
              "eDP-1".path = "${backgrounds."wallhaven-kxo38d_1920x1080.png"}";
            };
          };

          # Login-box geometry is per-output, so it belongs to the host rather
          # than the shared noctalia config.
          lockscreen_widgets = {
            widget_order = [
              "lockscreen-login-box@DP-3"
              "lockscreen-login-box@eDP-1"
            ];
            widget = {
              "lockscreen-login-box@DP-3" = {
                box_height = 0.0;
                box_width = 0.0;
                cx = 2560.0;
                cy = 1317.0;
                output = "DP-3";
                rotation = 0.0;
                type = "login_box";
              };
              "lockscreen-login-box@eDP-1" = {
                box_height = 0.0;
                box_width = 0.0;
                cx = 960.0;
                cy = 1077.0;
                output = "eDP-1";
                rotation = 0.0;
                type = "login_box";
              };
            };
          };
        };
      };
      obs-studio.enable = true;
    };
  };
}
