{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = false;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    polarity = "dark";

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts = with pkgs; {
      serif = {
        package = nerd-fonts.iosevka;
        name = "Iosevka NF";
      };

      sansSerif = {
        package = nerd-fonts.iosevka;
        name = "Iosevka NF";
      };

      monospace = {
        package = nerd-fonts.iosevka;
        name = "Iosevka NFM";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    targets = {
      waybar.enable = true;
      rofi.enable = true;
      mako.enable = true;
      gtk = {
        enable = false;
        extraCss = ''
          /*
          from comment: https://github.com/ghostty-org/ghostty/discussions/3190#discussioncomment-11690311
          debug: env GTK_DEBUG=interactive ghostty
          https://docs.gtk.org/gtk4/css-overview.html
          https://docs.gtk.org/gtk4/css-properties.html
          */

          headerbar {
            margin: 0;
            padding: 0;
            min-height: 20px;
          }

          tabbar tabbox {
            margin: 0;
            padding: 0;
            min-height: 10px;
            background-color: #1a1a1a;
            font-family: monospace;
          }

          tabbar tabbox tab {
            margin: 0;
            padding: 0;
            color: #9ca3af;
            border-right: 1px solid #374151;
          }

          tabbar tabbox tab:selected {
            background-color: #2d2d2d;
            color: #ffffff;
          }

          tabbar tabbox tab label {
            font-size: 13px;
          }
        '';
      };
    };
  };
}
