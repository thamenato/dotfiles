{
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "200, 50";
          outline_thickness = 3;

          outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          inner_color = "rgb(91, 96, 120)";

          check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
          fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";

          font_color = "rgb(202, 211, 245)";
          fade_on_empty = true;
          placeholder_text = "( ͡~ ͜ʖ ͡°)";
          rounding = 10;

          position = "0, -20";
          halign = "center";
          valign = "center";

          shadow_passes = 2;
        }
      ];
    };
  };
}
