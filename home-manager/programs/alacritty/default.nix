{
  programs.alacritty = {
    enable = false;

    settings = {
      env = {
        TERM = "xterm-256color";
      };

      general.import = [
        ./cyberdream.toml
      ];

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
