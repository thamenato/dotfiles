{pkgs, ...}: {
  programs.nvf = {
    enable = true;

    settings.vim = {
      # neovim config
      viAlias = false;
      vimAlias = true;
      preventJunkFiles = true;
      lineNumberMode = "number";

      options = {
        tabstop = 4;
        shiftwidth = 4;
        softtabstop = 4;
      };

      theme = {
        enable = true;
        name = "oxocarbon";
        style = "dark";
      };

      lsp = {
        enable = true;
        formatOnSave = true;
      };

      languages = {
        # defaults
        enableLSP = true;
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
          format = {
            type = "ruff";
          };
        };
        terraform.enable = true;
      };

      mini = {
        diff.enable = true;
        files.enable = true;
        git.enable = true;
        icons.enable = true;
        statusline.enable = true;
      };

      treesitter.grammars = with pkgs.tree-sitter-grammars; [
        tree-sitter-just
      ];

      visuals = {
        nvim-web-devicons.enable = true;
      };

      filetree = {
        nvimTree.enable = true;
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

      utility = {
        preview = {
          markdownPreview.enable = true;
        };
      };

      spellcheck.enable = true;

      comments = {
        # https://github.com/numToStr/Comment.nvim
        comment-nvim.enable = true;
      };

      telescope.enable = true;

      snippets.luasnip.enable = true;

      autocomplete.nvim-cmp.enable = true;

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
      in {
        "venv-selector.nvim" = {
          package = venv-selector;
          setup = "require('venv-selector').setup {}";
        };
      };

      # custom lazy plugins
      # lazy.plugins = with pkgs.vimPlugins; {
      #   vim-just = {
      #     package = vim-just;
      #     ft = "just";
      #   };
      # };
    };
  };
}
