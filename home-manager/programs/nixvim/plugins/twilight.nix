{
  programs.nixvim.plugins.twilight = {
    enable = true;
    settings = {
      context = 10;
      dimming = {
        alpha = 0.5;
      };
      expand = [
        "function"
        "method"
        "table"
        "if_statement"
      ];
      treesitter = true;
    };
  };
}
