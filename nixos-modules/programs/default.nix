{ config
, lib
, ...
}: {
  imports = [
    ./steam.nix
  ];

  steam.enable = lib.mkDefault false;
}
