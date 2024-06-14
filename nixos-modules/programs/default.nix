{ config
, lib
, ...
}: {
  imports = [
    ./steam.nix
    ./nh.nix
  ];

  steam.enable = lib.mkDefault false;

  # programs.sway.enable = true;
}
