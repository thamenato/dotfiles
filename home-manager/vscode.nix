{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    # do not let VSCode alter the folder, only Home-Manager
    mutableExtensionsDir = false;
    
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      vscodevim.vim
      codezombiech.gitignore
      waderyan.gitblame
      equinusocio.vsc-material-theme
    ];

    userSettings = {
      # vscode
      "window.menuBarVisibility" = "toggle";
      "editor.rulers" = [80 120];

      # extensions
      "workbench.colorTheme" = "Material Theme Palenight";
    };
  };
}

