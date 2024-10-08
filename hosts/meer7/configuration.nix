{ pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./../../nixos-modules
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-ab1df3b4-57db-440d-b340-b71db1de7e1d".device = "/dev/disk/by-uuid/ab1df3b4-57db-440d-b340-b71db1de7e1d";
  boot.initrd.luks.devices."luks-ab1df3b4-57db-440d-b340-b71db1de7e1d".keyFile = "/crypto_keyfile.bin";

  # Networking
  networking.hostName = "thales-meer7"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thales = {
    isNormalUser = true;
    description = "thales";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # system packages
  environment.systemPackages = with pkgs; [
    dbeaver-bin
    signal-desktop
    slack
    spotify
    system76-firmware
    tailscale
    tidal-hifi
  ];

  # enable 1password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "thales" ];
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
  users.extraGroups.docker.members = [ "thales" ];

  # services
  services.openssh.enable = true;
  services.tailscale.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
