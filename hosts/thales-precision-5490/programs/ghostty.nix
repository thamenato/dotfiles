{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    package = config.lib.nixGL.wrapOffload pkgs.ghostty;
  };
}
