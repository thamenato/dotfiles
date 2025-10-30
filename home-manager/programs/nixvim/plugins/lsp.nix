###############################################################################
# Brief aside: **What is LSP?**
#
# LSP is an initialism you've probably heard, but might not understand what it is.
#
# LSP stands for Language Server Protocol. It's a protocol that helps editors
# and language tooling communicate in a standardized fashion.
#
# In general, you have a "server" which is some tool built to understand a particular
# language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
# (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
# processes that communicate with some "client" - in this case, Neovim!
#
# LSP provides Neovim with features like:
#  - Go to definition
#  - Find references
#  - Autocompletion
#  - Symbol Search
#  - and more!
#
# Thus, Language Servers are external tools that must be installed separately from
# Neovim which are configured below in the `server` section.
#
# If you're wondering about lsp vs treesitter, you can check out the wonderfully
# and elegantly composed help section, `:help lsp-vs-treesitter`
###############################################################################
{
  programs.nixvim = {
    plugins = {
      cmp-nvim-lsp = {
        # Allows extra capabilities providied by nvim-cmp
        # https://nix-community.github.io/nixvim/plugins/cmp-nvim-lsp.html
        enable = true;
      };
      fidget = {
        # Useful status updates for LSP.
        # https://nix-community.github.io/nixvim/plugins/fidget/index.html
        enable = true;
      };
      lsp = {
        # https://nix-community.github.io/nixvim/plugins/lsp/index.html
        enable = true;

        luaConfig = {
          pre = ''
            vim.lsp.set_log_level("off")
          '';
        };

        servers = {
          # ansible
          ansiblels = {
            enable = true;
            package = null;
            filetypes = ["yaml.ansible" "ansible"];
          };
          # bash/shell
          bashls.enable = true;
          # cue
          cue.enable = true;
          # css
          cssls.enable = true;
          # go
          gopls.enable = true;
          # yaml
          yamlls = {
            enable = true;
            filetypes = ["yaml"];
          };
          # nix
          nixd.enable = true;
          # python
          basedpyright = {
            enable = true;
            settings = {
              basedpyright = {
                disableOrganizeImports = true;
                typeCheckingMode = "off";
                analysis = {
                  ignore = "*";
                };
              };
            };
          };
          ruff.enable = true;
          # markdown
          marksman.enable = true;
          # lua
          lua_ls.enable = true;
          # terraform / hcl
          terraformls.enable = true;
        };

        keymaps = {
          # Diagnostic keymaps
          diagnostic = {
            "<leader>q" = {
              mode = "n";
              action = "setloclist";
              desc = "Open diagnostic [Q]uickfix list";
            };
          };

          extra = [
            # Jump to the definition of the word under your cusor.
            #  This is where a variable was first declared, or where a function is defined, etc.
            #  To jump back, press <C-t>.
            {
              mode = "n";
              key = "gd";
              action.__raw = "require('telescope.builtin').lsp_definitions";
              options = {
                desc = "LSP: [G]oto [D]efinition";
              };
            }
            # Find references for the word under your cursor.
            {
              mode = "n";
              key = "gr";
              action.__raw = "require('telescope.builtin').lsp_references";
              options = {
                desc = "LSP: [G]oto [R]eferences";
              };
            }
            # Jump to the implementation of the word under your cursor.
            #  Useful when your language has ways of declaring types without an actual implementation.
            {
              mode = "n";
              key = "gI";
              action.__raw = "require('telescope.builtin').lsp_implementations";
              options = {
                desc = "LSP: [G]oto [I]mplementation";
              };
            }
            # Jump to the type of the word under your cursor.
            #  Useful when you're not sure what type a variable is and you want to see
            #  the definition of its *type*, not where it was *defined*.
            {
              mode = "n";
              key = "<leader>D";
              action.__raw = "require('telescope.builtin').lsp_type_definitions";
              options = {
                desc = "LSP: Type [D]efinition";
              };
            }
            # Fuzzy find all the symbols in your current document.
            #  Symbols are things like variables, functions, types, etc.
            {
              mode = "n";
              key = "<leader>ds";
              action.__raw = "require('telescope.builtin').lsp_document_symbols";
              options = {
                desc = "LSP: [D]ocument [S]ymbols";
              };
            }
            # Fuzzy find all the symbols in your current workspace.
            #  Similar to document symbols, except searches over your entire project.
            {
              mode = "n";
              key = "<leader>ws";
              action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
              options = {
                desc = "LSP: [W]orkspace [S]ymbols";
              };
            }
          ];

          lspBuf = {
            # Rename the variable under your cursor.
            #  Most Language Servers support renaming across files, etc.
            "<leader>rn" = {
              action = "rename";
              desc = "LSP: [R]e[n]ame";
            };
            # Execute a code action, usually your cursor needs to be on top of an error
            # or a suggestion from your LSP for this to activate.
            "<leader>ca" = {
              mode = ["n" "x"];
              action = "code_action";
              desc = "LSP: [C]ode [A]ction";
            };
            # WARN: This is not Goto Definition, this is Goto Declaration.
            #  For example, in C this would take you to the header.
            "gD" = {
              action = "declaration";
              desc = "LSP: [G]oto [D]eclaration";
            };
          };
        };
      };
    };

    autoGroups = {
      # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
      "kickstart-lsp-attach" = {
        clear = true;
      };
    };
  };
}
