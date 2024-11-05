{ meta, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Setup keyfile
  boot = {
    initrd = {
      secrets = {
        "/crypto_keyfile.bin" = null;
      };
      # Enable swap on luks
      luks.devices."luks-ab1df3b4-57db-440d-b340-b71db1de7e1d".device = "/dev/disk/by-uuid/ab1df3b4-57db-440d-b340-b71db1de7e1d";
      luks.devices."luks-ab1df3b4-57db-440d-b340-b71db1de7e1d".keyFile = "/crypto_keyfile.bin";
    };
  };

  # system packages
  environment.systemPackages = with pkgs; [
    dbeaver-bin
    signal-desktop
    slack
    system76-firmware
    tailscale
  ];

  # enable 1password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ meta.user ];
  };

  # docker
  virtualisation.docker = {
    daemon.settings = {
      bip = "172.26.0.1/24";
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
  };

  # services
  services.tailscale.enable = true;

  system.stateVersion = "23.05";
}
