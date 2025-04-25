{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugi#extraplugins
      neovim-trunk
    ];

    extraConfigLuaPost = ''
      require('trunk').setup {}
    '';
  };
}
