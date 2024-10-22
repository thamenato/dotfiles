{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "catppuccin"
    ];

    userSettings = {
      vim_mode = true;
      theme = {
        mode = "system";
        dark = "Catppuccin Frappé";
        light = "Catppuccin Frappé";
      };
    };
  };
}
