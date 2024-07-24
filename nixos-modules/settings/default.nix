{ config
, pkgs
, ...
}: {
  # set zsh as default shell
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # nix settings
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      allowed-users = [ "thamenato" "thales" ];
      trusted-users = [ "thamenato" "thales" ];
    };
    optimise.automatic = true;
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

  # enable opengl
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # support SANE scanners
  hardware.sane.enable = true;

  # https://nixos.wiki/wiki/Polkit
  security.polkit.enable = true;

  # kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_9;
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };
}
