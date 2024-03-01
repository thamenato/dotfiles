{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    # tools/cli
    bat
    curl
    dig
    git
    gnupg
    htop
    lf
    neovim
    pinentry
    python3
    wget

    # terminal
    alacritty
    kitty

    # apps
    easyeffects

    # browser
    brave
    firefox
  ];

  # set zsh as default shell
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    allowed-users = [ "thamenato" ];
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

  # configure keymap in X11
  services.xserver.xkb = {
    variant = "intl";
    layout = "us";
  };
  console.keyMap = "us-acentos";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.pcscd.enable = true;


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable docker
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      experimental = true;
      features = {
        containerd-snapshotter = true;
        buildkit = true;
      };
    };
  };

  # configure gnupg
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = null;
  };

  # https://nixos.wiki/wiki/Polkit
  security.polkit.enable = true;

  # kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_7;
  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
  };
}
