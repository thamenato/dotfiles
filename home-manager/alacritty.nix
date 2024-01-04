{
  programs.alacritty = {
    enable = true;

    settings = {
      window.padding = {
        x = 3;
        y = 3;
      };
      window.opacity = 0.9;

      font = {
        size = 10;
        normal = {
          family = "JetBrainsMono NF";
          style = "Regular";
        };
      };
    };
  };
}
