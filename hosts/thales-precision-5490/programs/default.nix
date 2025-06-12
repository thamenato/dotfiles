{lib, ...}: let
  disabled = lib.mkForce false;
  enabled = lib.mkForce true;
in {
  imports = [
    ./ghostty.nix
  ];

  programs = {
    go.enable = disabled;
    vscode.enable = enabled;
    rofi.enable = enabled;
    ncspot.enable = disabled;
  };
}
