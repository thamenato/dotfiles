{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = false;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
    polarity = "dark";

    # cursor = {
    #   package = pkgs.bibata-cursors;
    #   name = "Bibata-Modern-Ice";
    # };

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
    };
  };
}
