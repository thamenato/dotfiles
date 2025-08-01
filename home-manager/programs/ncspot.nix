{
  programs.ncspot = {
    enable = true;

    settings = {
      initial_screen = "library";
      use_nerdfont = true;
      gapless = true;

      theme = {
        # dracula - https://draculatheme.com/ncspot
        background = "black";
        primary = "#F8F8F2";
        secondary = "light black";
        title = "#bd93f9";
        playing = "#bd93f9";
        playing_selected = "#D0B3FA";
        playing_bg = "black";
        highlight = "#f8f8f2";
        highlight_bg = "#44475a";
        error = "#f8f8f2";
        error_bg = "#ff5555";
        statusbar = "black";
        statusbar_progress = "#bd93f9";
        statusbar_bg = "#bd93f9";
        cmdline = "#f8f8f2";
        cmdline_bg = "black";
        search_match = "#ff79c6";
      };
    };
  };
}
