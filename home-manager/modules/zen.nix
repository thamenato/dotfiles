{
  config,
  lib,
  zen-browser,
  ...
}: {
  options = {
    programs.zen-browser = {
      enable = lib.mkEnableOption "Zen Browser";
    };
  };

  config = lib.mkIf config.programs.zen-browser.enable {
    home.packages = [zen-browser];
  };
}
