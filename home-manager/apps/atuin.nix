{
  # app: Atuin
  # desc: replaces your existing shell history with a SQLite database, and
  #   records additional context for your commands.
  programs.atuin = {
    enable = true;
    settings = {
      keymap_mode = "vim-normal";
      sync = {
        records = true;
      };
    };
  };
}
