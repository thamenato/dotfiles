{pkgs, ...}: {
  services.dunst = {
    # notification
    enable = false;

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = "16x16";
    };

    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        # frame_color = "#eceff1";
        frame_width = 2;
        font = "Iosevka NF 10";
      };

      urgency_normal = {
        # background = "#37474f";
        # foreground = "#eceff1";
        timeout = 15;
      };
    };
  };
}
