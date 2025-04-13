{
  programs.nixvim.plugins.cursorline = {
    # Highlight words and lines on the cursor for Neovim
    # https://github.com/ya2s/nvim-cursorline
    enable = true;
    settings = {
      cursorline.enable = true;
      cursorword.enable = true;
    };
  };
}
