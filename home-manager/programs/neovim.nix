{
  programs.nvf = {
    enable = true;

    settings.vim = {
      viAlias = false;
      vimAlias = true;
      preventJunkFiles = true;
      lineNumberMode = "number";

      options = {
        tabspot = 4;
      };

      theme = {
        enable = true;
        name = "gruvbox";
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
      };

      utility = {
        preview = {
          markdownPreview.enable = true;
        };
      };

      spellcheck.enable = true;
      statusline.lualine.enable = true;
      telescope.enable = true;
      autocomplete.nvim-cmp.enable = true;
    };
  };
}
