# {pkgs, ...}:
{pkgs ? import <nixpkgs> {}}:
# pkgs.callPackage ./derivation.nix {};
{
  systemd.services.falcon-sensor = {
    enable = true;
    description = "CrowdStrike Falcon Sensor";
  };
}
