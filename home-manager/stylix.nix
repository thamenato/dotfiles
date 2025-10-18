{pkgs, ...}: {
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

    targets = {
      zen-browser.profileNames = ["default"];
      hyprlock.enable = false;
    };
  };
}
