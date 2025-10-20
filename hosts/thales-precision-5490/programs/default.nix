{
  lib,
  pkgs,
  ...
}: let
  disabled = lib.mkForce false;
in {
  imports = [
    ./ghostty.nix
    ./git.nix
    ./zen.nix
  ];

  programs = {
    go.enable = disabled;

    ncspot = {
      package = pkgs.emptyDirectory;
    };
  };
}
