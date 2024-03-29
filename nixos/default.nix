{ config
, pkgs
, ...
}: {
  imports = [
    ./packages.nix
    ./services.nix
  ];

  # set zsh as default shell
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    allowed-users = [ "thamenato" "thales" ];
  };

  # localization
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  console.keyMap = "us-acentos";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # configure gnupg
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # pinentryPackage = null;
  };

  # https://nixos.wiki/wiki/Polkit
  security.polkit.enable = true;

  # kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_8;
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };
}

