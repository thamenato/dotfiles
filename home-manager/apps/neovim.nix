{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;

    # theme
    colorschemes.gruvbox.enable = true;

    # vim.g.*
    globals = { };

    # vim.o.*
    options = {
      number = true;
      tabstop = 4;
      shiftwidth = 4;
      mouse = "a";
    };

    # plugins supported by nixvim
    plugins = {
      lualine.enable = true;
      luasnip.enable = true;
      oil.enable = true;
      telescope.enable = true;
      treesitter.enable = true;

      lsp = {
        enable = true;

        servers = {
          # javascript/typescript
          tsserver.enable = true;
          # lua
          lua-ls.enable = true;
          # terraform
          terraformls.enable = true;
          # python
          pylsp.enable = true;
        };
      };

      # nvim-cmp = {
      #   enable = true;
      #   sources = [
      #     { name = "nvim_lsp"; }
      #     { name = "path"; }
      #     { name = "buffer"; }
      #   ];

      #   mapping = {
      #     "<CR>" = "cmp.mapping.confirm({ select = true })";
      #     "<Tab>" = {
      #       action = ''
      #         function(fallback)
      #           if cmp.visible() then
      #             cmp.select_next_item()
      #           elseif luasnip.expandable() then
      #             luasnip.expand()
      #           elseif luasnip.expand_or_jumpable() then
      #             luasnip.expand_or_jump()
      #           elseif check_backscape() then
      #             fallback()
      #           else
      #             fallback()
      #           end
      #         end
      #       '';
      #       modes = [ "i" "s" ];
      #     };
      #   };
      # };

    };
  };
}
