{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "catppuccin themes"
    ];

    userSettings = {
      vim_mode = true;
      theme = {
        mode = "system";
        dark = "Catppuccin Mocha";
        light = "Catppuccin Mocha";
      };
    };
  };
}
