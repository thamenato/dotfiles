{
  programs.helix = {
    enable = true;
    defaultEditor = false;

    settings = {
      theme = "autumn";
      editor = {
        rulers = [ 80 ];
      };
    };

    languages = {
      language = [
        {
          name = "hcl";
          formatter = {
            command = "terraform";
            args = [ "fmt" "-" ];
          };
        }
        {
          name = "python";
          auto-format = true;
          formatter = {
            command = "black";
            args = [ "-" ];
          };
        }
        {
          name = "markdown";
          auto-format = true;
          formatter = {
            command = "dprint";
            args = [ "fmt" "--stdin" "md" ];
          };
        }
      ];
    };
  };
}
