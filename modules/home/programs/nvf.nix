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
            # conform preset names, applied in list order: lint --fix, then
            # format. These are nvf's presets (store-path-pinned ruff), not
            # conform's builtin ruff_fix / ruff_format names.
            format.type = [
              "ruff-fix"
              "ruff"
            ];
            # ty owns types, ruff's server owns lint and code actions. ty is
            # still pre-1.0; swap "ty" for "basedpyright" if it falls short, and
            # pin basedpyright's typeCheckingMode to "standard" if you do -- its
            # own default is "recommended", which errors on every unannotated
            # parameter, unknown inferred type and missing stub.
            lsp.servers = [
              "ty"
              "ruff"
            ];
            # A bare nix mypy has none of the project's dependencies installed,
            # so it reports import-untyped for every third-party import.
            extraDiagnostics.enable = false;
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

        # formatters_by_ft is deliberately left unset: it is types.attrs, so a
        # definition here shallow-merges last-write-wins against the entries
        # vim.languages.<lang>.format.type generates, and can silently lose.
        formatter.conform-nvim.enable = true;

        diagnostics = {
          enable = true;

          # Set through nvf's option rather than a raw `linters_by_ft = {...}` in
          # a plugin setup string, which replaces the whole table and so clobbers
          # the linters nvf registers for every other filetype.
          nvim-lint.linters_by_ft."yaml.ansible" = ["ansible_lint"];

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
            # The stock cwd/workspace/file searches pass -I (ignore .gitignore)
            # and -L (follow symlinks), so inside a bazel repo they walk the
            # output base through the bazel-* convenience symlinks and offer
            # bazel's hermetic toolchain interpreters as if they were venvs.
            # Excluding bazel-* keeps the picker to real project venvs.
            setup = ''
              require('venv-selector').setup {
                search = {
                  cwd = {
                    command = "$FD '/bin/python$' '$CWD' --full-path --color never -HI -a -L -E /proc -E .git/ -E 'bazel-*' -E site-packages/",
                  },
                  workspace = {
                    command = "$FD '/bin/python$' '$WORKSPACE_PATH' --full-path --color never -HI -a -L -E /proc -E .git/ -E 'bazel-*' -E site-packages/",
                  },
                  file = {
                    command = "$FD '/bin/python$' '$FILE_DIR' --full-path --color never -HI -a -L -E /proc -E .git/ -E 'bazel-*' -E site-packages/",
                  },
                },
              }
            '';
          };
          # trunk = {
          #   package = neovim-trunk;
          #   setup = "require('trunk').setup {}";
          # };
        };
      };
    };
  };
}
