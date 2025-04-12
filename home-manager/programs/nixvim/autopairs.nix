{
  programs.nixvim = {
    plugins.nvim-autopairs = {
      # Inserts matching pairs of parens, brackets, etc.
      # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html
      enable = true;
    };

    # If you want to automatically add `(` after selecting a function or method
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglua#extraconfiglua
    extraConfigLua = ''
      require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
    '';
  };
}
