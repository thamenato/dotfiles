{
  programs.rofi = {
    enable = true;
    theme = {
      "*" = {
        width = 600;
      };

      window = {
        height = "360px";
        border = "3px";
      };

      inputbar = {
        children = ["prompt" "entry"];
        border-rarius = "5px";
        padding = "2px";
      };

      prompt = {
        "padding" = "6px";
        "border-radius" = "3px";
        "margin" = ["20px" "0px" "0px" "20px"];
      };

      textbox-prompt-colon = {
        "expand" = false;
        "str" = ":";
      };

      entry = {
        "padding" = "6px";
        "margin" = ["20px" "0px" "0px" "10px"];
      };

      listview = {
        "border" = ["0px" "0px" "0px"];
        "padding" = ["6px" "0px" "0px"];
        "margin" = ["10px" "0px" "0px" "20px"];
        "columns" = 2;
        "lines" = 5;
      };

      element = {
        "padding" = "5px";
      };

      element-icon = {
        "size" = "25px";
      };

      mode-switcher = {
        "spacing" = 0;
      };

      button = {
        "padding" = "10px";
        "vertical-align" = "0.5";
        "horizontal-align" = "0.5";
      };

      message = {
        "margin" = "2px";
        "padding" = "2px";
        "border-radius" = "5px";
      };

      textbox = {
        "padding" = "6px";
        "margin" = ["20px" "0px" "0px" "20px"];
      };
    };
  };
}
