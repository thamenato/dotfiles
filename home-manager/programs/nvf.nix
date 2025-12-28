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

        # Save undo history
        undofile = true;

        # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
        ignorecase = true;
        smartcase = true;

        # Keep signcolumn on by default
        signcolumn = "yes";

        # if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
        # instead raise a dialog asking if you wish to save the current file(s)
        # See `:help 'confirm'`
        confirm = true;
      };

      theme = {
        enable = true;
        name = "rose-pine";
        style = "main";
        transparent = true;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };

      filetree = {
        nvimTree = {
          enable = true;
        };
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        # lspSignature.enable = true;
      };

      languages = {
        # defaults
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
          format.type = ["ruff"];
          lsp.servers = ["python-lsp-server"];
        };
        terraform.enable = true;
      };

      mini = {
        ai.enable = true;
        diff.enable = true;
        # git.enable = true;
        icons.enable = true;
        notify.enable = true;
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
        cheatsheet.enable = true;
        hardtime-nvim.enable = true;
        whichKey.enable = true;
      };

      git = {
        gitsigns.enable = true;
        git-conflict.enable = true;
      };

      autopairs.nvim-autopairs.enable = true;

      utility = {
        direnv.enable = true;
      };

      spellcheck.enable = true;

      comments = {
        # https://github.com/numToStr/Comment.nvim
        comment-nvim.enable = true;
      };

      telescope.enable = true;

      snippets.luasnip = {
        enable = true;
        customSnippets.snipmate = {
          sh = [
            {
              trigger = "header";
              body = ''
                ################################################################################
                # $1
                ################################################################################
              '';
            }
          ];
        };
      };

      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        mappings = {
          complete = "<C-Space>";
          confirm = "<C-y>";
          next = "<C-n>";
          previous = "<C-p>";
        };
        setupOpts = {
          signature.enable = true;
        };
      };

      formatter = {
        conform-nvim = {
          enable = true;
          setupOpts = {
            formatters_by_ft = {
              nix = ["alejandra"];
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

      autocmds = [
        {
          event = ["BufRead" "BufNewFile"];
          pattern = [
            "*/ansible/*.yml"
            "*/ansible/*.yaml"
            "*/playbooks/*.yml"
            "*/playbooks/*.yaml"
            "*/roles/*.yml"
            "*/roles/*.yaml"
          ];
          command = "set filetype=yaml.ansible";
        }
      ];
      extraPlugins = with pkgs.vimPlugins; {
        "venv-selector.nvim" = {
          package = venv-selector-nvim;
          setup = "require('venv-selector').setup {}";
        };
        trunk = {
          package = neovim-trunk;
          setup = "require('trunk').setup {}";
        };
      };
    };
  };
}
