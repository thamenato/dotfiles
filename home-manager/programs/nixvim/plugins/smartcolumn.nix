{
  programs.nixvim.plugins.smartcolumn = {
    # A Neovim plugin hiding your colorcolumn when unneeded.
    # https://github.com/m4xshen/smartcolumn.nvim
    enable = true;
    settings = {
      colorcolumn = "100";
      custom_colorcolumn = {
        go = [
          "90"
          "130"
        ];
        nix = [
          "100"
          "120"
        ];
        rust = [
          "80"
          "100"
        ];
        python = [
          "80"
          "100"
        ];
      };
      disabled_filetypes = [
        "checkhealth"
        "help"
        "lspinfo"
        "markdown"
        "neo-tree"
        "noice"
        "text"
      ];
      scope = "window";
    };
  };
}
