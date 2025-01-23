{meta, ...}: {
  networking = {
    hostName = meta.hostName;
    networkmanager.enable = true;
  };
}
