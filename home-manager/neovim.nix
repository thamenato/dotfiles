{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    extraPlugins = [ pkgs.vimPlugins.gruvbox ];

    colorscheme = "gruvbox";

    # vim.g.*
    globals = {};

    # vim.o.*
    options = {
      number = true;
      tabstop = 4;
      shiftwidth = 4;
      mouse = "a";
    };

    plugins = {
      lsp = {
        enable = true;

        servers = {
          tsserver.enable = true;
          lua-ls.enable = true;
          terraformls.enable = true;
          pylsp.enable = true;
        };
      };

      telescope = {
        enable = true;
      };
    };
  };
}

