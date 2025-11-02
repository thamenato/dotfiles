{pkgs, ...}: {
  programs.nixvim = {
    # NOTE: This is where you would add a vim plugin that is not implemented in Nixvim, also see extraConfigLuaPre below
    extraPlugins = let
      # based on https://github.com/NixOS/nixpkgs/issues/378818
      venv-selector = pkgs.vimUtils.buildVimPlugin {
        pname = "venv-selector.nvim";
        version = "2025-10-21";
        src = pkgs.fetchFromGitHub {
          owner = "linux-cultist";
          repo = "venv-selector.nvim";
          rev = "9d528643ab17795c69dc42ce018120c397a36f8b";
          sha256 = "03jag019p5kfwghff0f1w0xk3sfkpza71pprpm7gnwxi49y77pvi";
        };
        meta.homepage = "https://github.com/linux-cultist/venv-selector.nvim/";
        nvimSkipModule = [
          "venv-selector.cached_venv"
        ];
      };
    in [
      venv-selector
    ];

    # The line beneath this is called `modeline`. See `:help modeline`
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapost
    extraConfigLuaPost = ''
      require('venv-selector').setup {}
    '';
  };
}
