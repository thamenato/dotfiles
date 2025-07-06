# Credits:
#  - loosely copied/inspired by https://github.com/JMartJonesy/kickstart.nixvim
#
{
  imports = [
    ./plugins
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    colorschemes = {
      cyberdream = {
        enable = true;
        settings = {
          transparent = true;
        };
      };
      # rose-pine.enable = true;
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

    diagnostic = {
      settings = {
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

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapost
    # The line beneath this is called `modeline`. See `:help modeline`
    extraConfigLuaPost = ''
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        callback = function()
          vim.opt_local.tabstop = 4
          vim.opt_local.shiftwidth = 4
          vim.opt_local.softtabstop = 4
          vim.opt_local.expandtab = true  -- Use spaces instead of tabs
        end,
      })
    '';
  };
}
