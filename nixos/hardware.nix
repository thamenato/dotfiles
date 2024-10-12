{
  hardware = {
    # Enable sound with pipewire.
    pulseaudio.enable = false;

    # enable opengl
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # support SANE scanners
    sane.enable = true;
  };
}
