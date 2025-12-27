{pkgs, ...}: {
  programs.nvf = {
    enable = true;

    settings.vim = {
      # neovim config
      viAlias = false;
      vimAlias = true;
      preventJunkFiles = true;
      lineNumberMode = "relative";

      options = {
        tabstop = 4;
        shiftwidth = 4;
        softtabstop = 4;
      };

      # theme = {
      #   enable = true;
      #   name = "dracula";
      #   style = "dark";
      # };

      # keymaps = [
      #   {
      #     key = "<leader>tf";
      #     mode = ["n"];
      #     action = ":lua MiniFiles.open()<cr>";
      #     desc = "Open mini.files";
      #     silent = true;
      #   }
      # ];

      lsp = {
        enable = true;
        formatOnSave = true;
        lspSignature.enable = true;
      };

      languages = {
        # defaults
        enableLSP = true;
        enableDAP = true;
        enableTreesitter = true;
        enableFormat = true;
        enableExtraDiagnostics = true;

        # languages
        bash.enable = true;
        cue.enable = true;
        go.enable = true;
        html.enable = true;
        markdown = {
          enable = true;
          format.enable = false;
          extensions.render-markdown-nvim.enable = true;
          extraDiagnostics.enable = true;
        };
        nix = {
          enable = true;
          treesitter.enable = false;
        };
        python = {
          enable = true;
          format.type = "ruff";
        };
        terraform.enable = true;
      };

      mini = {
        ai.enable = true;
        diff.enable = true;
        files.enable = true;
        git.enable = true;
        icons.enable = true;
        notify.enable = true;
        starter.enable = true;
        statusline.enable = true;
        surround.enable = true;
      };

      treesitter.grammars = with pkgs.tree-sitter-grammars; [
        tree-sitter-just
      ];

      visuals = {
        nvim-web-devicons.enable = true;
        nvim-cursorline = {
          enable = true;
          setupOpts = {
            cursorline.enable = true;
            cursorword.enable = true;
          };
        };
        highlight-undo.enable = true;
        indent-blankline.enable = true;
      };

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      git = {
        gitsigns.enable = true;
        git-conflict.enable = true;
      };

      autopairs.nvim-autopairs.enable = true;

      utility = {};

      spellcheck.enable = true;

      comments = {
        # https://github.com/numToStr/Comment.nvim
        comment-nvim.enable = true;
      };

      telescope.enable = true;

      snippets.luasnip.enable = true;

      autocomplete.nvim-cmp.enable = true;

      formatter = {
        conform-nvim = {
          enable = true;
          setupOpts = {
            formatters_by_ft = {
              python = [
                "ruff_fix"
                "ruff_format"
                "ruff_organize_imports"
              ];
            };
          };
        };
      };

      diagnostics = {
        enable = true;

        config = {
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
      };

      ui = {
        noice.enable = true;
        smartcolumn = {
          enable = true;
          setupOpts.custom_colorcolumn = {
            markdown = "80";
            python = "80";
            nix = "110";
            go = ["90" "130"];
          };
        };
      };

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
        # had this merged to nixpkgs, can remove once it hits unstable
        neovim-trunk = pkgs.vimUtils.buildVimPlugin {
          pname = "neovim-trunk";
          version = "0.1.3";
          src = pkgs.fetchFromGitHub {
            owner = "trunk-io";
            repo = "neovim-trunk";
            rev = "4465bd62095741812e63b5c0a017889420c212bf";
            sha256 = "1kwdl25m211crfqzpj1b459qjd955w1i2p675j25dav917bqmwf5";
          };
          meta.homepage = "https://github.com/trunk-io/neovim-trunk";
        };
      in {
        "venv-selector.nvim" = {
          package = venv-selector;
          setup = "require('venv-selector').setup {}";
        };
        trunk = {
          package = neovim-trunk;
          setup = "require('trunk').setup {}";
        };
      };

      # custom lazy plugins
      lazy.plugins = {
        # vim-just = {
        #   package = vim-just;
        #   ft = "just";
        # };
      };
    };
  };
}
