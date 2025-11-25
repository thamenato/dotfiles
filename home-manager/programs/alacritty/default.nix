{
  programs.alacritty = {
    enable = true;

    settings = {
      env = {
        TERM = "xterm-256color";
      };

      window.padding = {
        x = 3;
        y = 3;
      };
    };
  };
}
