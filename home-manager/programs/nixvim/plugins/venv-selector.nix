{pkgs, ...}: {
  programs.nixvim = {
    # NOTE: This is where you would add a vim plugin that is not implemented in Nixvim, also see extraConfigLuaPre below
    extraPlugins = let
      # based on https://github.com/NixOS/nixpkgs/issues/378818
      venv-selector = pkgs.vimUtils.buildVimPlugin {
        pname = "venv-selector.nvim";
        version = "2025-03-22";
        src = pkgs.fetchFromGitHub {
          owner = "linux-cultist";
          repo = "venv-selector.nvim";
          rev = "c677caa1030808a9f90092e522de7cc20c1390dd";
          sha256 = "1wz9fci60ii4c2k04vxzd74vrdhfyg60s6smm0xbyvc8x57ph1x2";
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
