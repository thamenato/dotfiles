{
  programs.nixvim = {
    plugins.dashboard = {
      enable = true;
      settings = {
        theme = "doom";
        change_to_vcs_root = true;
        config = {
          vertical_center = true;
          header = [
            "                                            ,,                    "
            "                                            db                    "
            "                                                                  "
            "`7MMpMMMb.   .gP\"Ya   ,pW\"Wq.  `7M'   `MF'`7MM  `7MMpMMMb.pMMMb.  "
            "  MM    MM  ,M'   Yb 6W'   `Wb   VA   ,V    MM    MM    MM    MM  "
            "  MM    MM  8M\"\"\"\"\"\" 8M     M8    VA ,V     MM    MM    MM    MM  "
            "  MM    MM  YM.    , YA.   ,A9     VVV      MM    MM    MM    MM  "
            ".JMML  JMML. `Mbmmd'  `Ybmd9'       W     .JMML..JMML  JMML  JMML."
            "                                                                  "
          ];

          center = [
            {
              icon = "   ";
              icon_hl = "Title";
              desc = "Find File";
              desc_hl = "String";
              key = "b";
              key_hl = "Number";
              key_format = " %s"; # remove default surrounding `[]`
              action = "Telescope find_files";
            }
            {
              icon = "󰩈   ";
              icon_hl = "Quit";
              desc = "Exit Neovim";
              desc_hl = "String";
              key = "q";
              key_hl = "Number";
              key_format = " %s";
              action = "quit";
            }
          ];

          footer = [
            "Made with ❤️"
          ];
        };
      };
    };
  };
}
