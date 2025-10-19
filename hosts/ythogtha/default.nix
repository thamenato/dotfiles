{
  lib,
  backgrounds,
  ...
}: {
  wayland.windowManager = let
    qhdUltraWide = "5120x1440@120";
  in {
    hyprland = {
      settings = {
        monitor = lib.mkForce [",${qhdUltraWide},auto,1"];
      };
    };
  };
  stylix.image = "${backgrounds."wallhaven-rrvygj_5120x1440.png"}";
}
