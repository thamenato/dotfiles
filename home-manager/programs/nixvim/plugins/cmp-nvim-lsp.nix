{
  programs.nixvim = {
    plugins.cmp-nvim-lsp = {
      # Allows extra capabilities providied by nvim-cmp
      # https://nix-community.github.io/nixvim/plugins/cmp-nvim-lsp.html
      enable = true;
    };
  };
}
