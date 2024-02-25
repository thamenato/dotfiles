{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    extraPlugins = [ pkgs.vimPlugins.gruvbox ];
    colorscheme = "gruvbox";
  };
}

