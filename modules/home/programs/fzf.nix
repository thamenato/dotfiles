# modules/home/programs/fzf.nix
{...}: {
  flake.homeModules."programs/fzf" = {...}: {
    programs.fzf = {
      # https://github.com/junegunn/fzf
      enable = true;
      # Atuin owns Ctrl-R for shell history; disable fzf's binding to avoid the
      # conflict. fzf keeps its Ctrl-T (files) and Alt-C (cd) widgets.
      historyWidget.command = "";
    };
  };
}
