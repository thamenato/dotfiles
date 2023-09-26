{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "autumn";
      editor = {
        rulers = [80];
      };
    };

    languages = {
      language = [
        {
          name = "hcl";
          formatter = {
            command = "terraform";
            args = ["fmt" "-"];
          };
        }       
        {
          name = "python";
          auto-format = true;
          formatter = {
            command = "black";
            args = ["-"];
          };
        }
      ];
    };
  };
}
