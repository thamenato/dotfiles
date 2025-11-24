{
  programs.opencode = {
    enable = true;
    settings = {
      permission = {
        # https://opencode.ai/docs/permissions/#_top
        edit = "allow";
        bash = "ask";
        webfetch = "ask";
        doom_loop = "ask";
        external_directory = "ask";
      };
    };
  };
}
