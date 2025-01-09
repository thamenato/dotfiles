{ ... }:
{
  programs.nvf = {
    enable = true;
    # your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings.vim = {
      viAlias = false;
      vimAlias = true;
      theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
      };
      lsp = {
        enable = true;
      };
      languages = {
        nix.enable = true;
        python.enable = true;
        markdown.enable = true;
        html.enable = true;
        go.enable = true;
      };
    };
  };

  # theme
  # colorschemes.gruvbox.enable = true;

  # vim.g.*
  # globals = { };

  # vim.o.*
  # opts = {
  # number = true;
  # tabstop = 4;
  # shiftwidth = 4;
  # mouse = "a";
  # };
}
