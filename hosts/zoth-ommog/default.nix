{
  utils,
  backgrounds,
  ...
}: let
  background = utils.mkSwaybg [
    {
      output = "HDMI-A-1";
      image = "${backgrounds."wallhaven-d6jzvg_3840x2160.png"}";
    }
  ];
in {
  programs.niri.settings = {
    spawn-at-startup = [
      background
    ];

    outputs = {
      "HDMI-A-1" = {
        mode = {
          width = 4096;
          height = 2160;
          refresh = 120.000;
        };
        scale = 2;
      };
    };
  };
}
