{
  config,
  lib,
  zen-browser,
  ...
}: {
  options = {
    programs.zen-browser = {
      enable = lib.mkEnableOption "Zen Browser";
      package = lib.mkOption {
        default = zen-browser;
      };
    };
  };

  config = lib.mkIf config.programs.zen-browser.enable {
    home.packages = [config.programs.zen-browser.package];
  };
}
