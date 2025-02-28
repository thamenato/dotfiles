{lib, ...}: let
  disabled = lib.mkForce false;
  enabled = lib.mkForce true;
in {
  imports = [
    ./autorandr.nix
    ./ghostty.nix
    ./starship.nix
  ];

  programs = {
    alacritty.enable = disabled;
    go.enable = disabled;
    hyprlock.enable = disabled;
    kitty.enable = disabled;
    vscode.enable = enabled;
    waybar.enable = disabled;
  };
}
