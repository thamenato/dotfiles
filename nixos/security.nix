{
  security = {
    # enable RealtimeKit - PulseAudio server uses this to acquire realtime priority
    rtkit.enable = true;

    # https://nixos.wiki/wiki/Polkit
    polkit.enable = true;
  };
}
