{
  programs.nixvim = {
    plugins.fidget = {
      # Useful status updates for LSP.
      # https://nix-community.github.io/nixvim/plugins/fidget/index.html
      enable = true;
    };
  };
}
