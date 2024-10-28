{ ... }:
{
  # Enable pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # mount thumbdrive
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # configure keymap in X11
  services.xserver.xkb = {
    variant = "intl";
    layout = "us";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.pcscd.enable = true;

  # Enable the windowing system.
  # services.displayManager = {
  #   ly = {
  #     enable = true;
  #   };
  # };

  services.xserver = {
    enable = true;

    displayManager.gdm.enable = true;
    desktopManager = {
      gnome.enable = true;
    };
  };

}
