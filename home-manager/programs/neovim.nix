{
  programs.nvf = {
    enable = true;

    settings.vim = {
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
        go.enable = true;
        html.enable = true;
        markdown = {
          enable = true;
          extensions.render-markdown-nvim.enable = true;
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

      filetree = {
        neo-tree.enable = true;
      };

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false;
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
        comment-nvim.enable = true;
      };

      statusline = {
        lualine = {
          enable = true;
          # theme = "catppuccin";
        };
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
    };
  };
}
