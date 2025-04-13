# Credits:
#  - loosely copied/inspired by https://github.com/JMartJonesy/kickstart.nixvim
#
{pkgs, ...}: {
  imports = [
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes = {
      rose-pine.enable = true;
      # tokyonight = {
      #   enable = true;
      #   settings.style = "night";
      # };
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#globals
    globals = {
      # Set <space> as the leader key
      # See `:help mapleader`
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = true;
    };

    clipboard = {
      providers = {
        wl-copy.enable = true;
        xsel.enable = true;
      };
      register = "unnamedplus";
    };

    opts = {
      # Show line numbers
      number = true;

      # Don't show the mode, since it's already in the statusline
      showmode = false;

      # Save undo history
      undofile = true;

      # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
      ignorecase = true;
      smartcase = true;

      # Keep signcolumn on by default
      signcolumn = "yes";

      # Decrease mapped sequence wait time
      # Displays which-key popup sooner
      timeoutlen = 300;

      # if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
      # instead raise a dialog asking if you wish to save the current file(s)
      # See `:help 'confirm'`
      confirm = true;

      # https://neovim.io/doc/user/spell.html
      spell = true;
      spelllang = ["en_us"];
    };

    diagnostics = {
      virtual_text = true;
      underline = false;
      signs = true;
      float = {
        focusable = false;
        style = "minimal";
        border = "rounded";
        source = "always";
        header = "";
        prefix = "";
      };
    };

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
    in
      with pkgs.vimPlugins; [
        # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugi#extraplugins
        neovim-trunk
        venv-selector
      ];

    # The line beneath this is called `modeline`. See `:help modeline`
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapost
    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
      require('venv-selector').setup {}
    '';
  };
}
