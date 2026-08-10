# modules/home/programs/nvf.nix
{...}: {
  flake.homeModules."programs/nvf" = {pkgs, ...}: {
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
            setupOpts = {
              view = {
                # An attrset (rather than an int) sizes the window dynamically to
                # the longest visible line, between min and max.
                width = {
                  min = 30;
                  max = 70;
                  padding = 1;
                };
                preserve_window_proportions = true;
              };
              renderer = {
                indent_width = 1; # default 2; halves the per-level indent cost
                group_empty = true; # collapse single-child directory chains
                full_name = true; # float the full name when it is truncated
              };
              actions = {
                # Re-rooting with <C-]> issues :cd rather than :lcd, so telescope
                # and grep follow the new root instead of only the tree window.
                change_dir.global = true;
                open_file = {
                  window_picker = {
                    enable = true;
                  };
                  resize_window = true;
                };
              };
            };
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
            extensions.render-markdown-nvim.enable = true;
            extraDiagnostics.enable = true;
            format.enable = false;
            lsp.servers = ["rumdl"];
          };
          nix = {
            enable = true;
            treesitter.enable = false;
          };
          python = {
            enable = true;
            format.type = ["ruff"];
            lsp.servers = ["basedpyright"];
          };
          terraform.enable = true;
          yaml.enable = true;
        };

        mini = {
          ai.enable = true;
          # git.enable = true;
          icons.enable = true;
          statusline.enable = true;
          surround.enable = true;
        };

        # nvim-tree resolves icons only via require("nvim-web-devicons") and nvf's
        # nvimTree module never enables that plugin, so it renders without icons.
        # Register mini.icons under that module name instead of pulling in a second
        # icon provider. Must run after mini.icons setup, which luaConfigPost does.
        luaConfigPost = ''
          require("mini.icons").mock_nvim_web_devicons()
        '';

        treesitter.grammars = with pkgs.tree-sitter-grammars; [
          tree-sitter-just
        ];

        visuals = {
          nvim-cursorline = {
            enable = true;
            setupOpts = {
              cursorline.enable = true;
              cursorword.enable = false;
            };
          };
          indent-blankline.enable = true;
        };

        binds = {
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

        # Commenting uses Neovim's built-in gc/gcc (native since 0.10).

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
              go = [
                "90"
                "130"
              ];
            };
          };
        };

        autocmds = [
          {
            event = [
              "BufRead"
              "BufNewFile"
            ];
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
          # trunk = {
          #   package = neovim-trunk;
          #   setup = "require('trunk').setup {}";
          # };
          "nvim-lint" = {
            package = nvim-lint;
            setup = ''
              require('lint').linters_by_ft = {
                ['yaml.ansible'] = {'ansible_lint'},
              }

              -- Run linter on save
              vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                  require("lint").try_lint()
                end,
              })
            '';
          };
        };
      };
    };
  };
}
