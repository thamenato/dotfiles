{pkgs, ...}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

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
      zen-browser.profileNames = ["default"];
      hyprlock.enable = false;
    };
  };
}
