{
  utils,
  backgrounds,
  ...
}: let
  background = utils.mkSwaybg [
    {
      output = "eDP-1";
      image = "${backgrounds."wallhaven-kxo38d_1920x1080.png"}";
    }
  ];
in {
  programs.niri.settings.spawn-at-startup = [
    background
  ];
}
