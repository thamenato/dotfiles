{ config, pkgs, ...}:

{
 environment.systemPackages = with pkgs; [
    home-manager
    wget
    git
    helix
    vivaldi
    vivaldi-ffmpeg-codecs
    signal-desktop
    whatsapp-for-linux
  ];
}
