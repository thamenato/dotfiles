{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugi#extraplugins
      neovim-trunk
    ];

    extraConfigLuaPost = ''
      if vim.fn.executable('trunk') == 1 then
        -- Only require and setup the trunk plugin if the binary exists
        require('trunk').setup({})
      end
    '';
  };
}
