{ pkgs, ... }: {
  programs.vscode = {
    enable = true;

    # do not let VSCode alter the folder, only Home-Manager
    mutableExtensionsDir = false;

    # disable checking for remote updates
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    extensions = with pkgs.vscode-extensions; [
      adpyke.codesnap
      bierner.emojisense
      charliermarsh.ruff
      codezombiech.gitignore
      github.vscode-github-actions
      hashicorp.terraform
      jdinhlife.gruvbox
      jnoortheen.nix-ide
      mikestead.dotenv
      ms-python.python
      ms-vscode-remote.remote-containers
      redhat.ansible
      redhat.vscode-yaml
      streetsidesoftware.code-spell-checker
      tamasfe.even-better-toml
      timonwong.shellcheck
      vscode-icons-team.vscode-icons
      vscodevim.vim
      waderyan.gitblame
      # xyz.local-history
      yzhang.markdown-all-in-one
    ];

    userSettings = {
      # ui
      "window.menuBarVisibility" = "toggle";
      "workbench.colorTheme" = "Gruvbox Dark Medium";
      "workbench.iconTheme" = "vscode-icons";

      # editor
      "editor.rulers" = [ 80 120 ];
      "editor.fontFamily" = "'JetBrainsMono NF', 'monospace'";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.inlineSuggest.enabled" = true;
      "editor.codeActionsOnSave" = {
        "source.organizeImports.ruff" = "explicit";
      };

      # languages
      "[terraform]" = { "editor.tabSize" = 2; };
      "[python]" = { "editor.defaultFormatter" = "charliermarsh.ruff"; };
      "[github-actions-workflow]" = { "editor.tabSize" = 2; };
      "[markdown]" = { "editor.defaultFormatter" = "yzhang.markdown-all-in-one"; };

      # extensions
      "codesnap.realLineNumbers" = true;
      "codesnap.showWindowControls" = false;
      "codesnap.showWindowTitle" = true;
      "codesnap.transparentBackground" = true;

      "git.inputValidationLength" = 72;
      "git.inputValidationSubjectLength" = 50;
      "[git-commit]" = {
        "editor.rulers" = [ 72 50 ];
        "editor.wordWrap" = "off";
        "workbench.editor.restoreViewState" = false;
      };

      # "local-history.daysLimit" = 7;
      # "local-history.exclude" = [
      #   "**/.vscode/**"
      #   "**/node_modules/**"
      #   "**/typings/**"
      #   "**/out/**"
      #   "**/Code/User/**"
      # ];

      "terraform.languageServer" = {
        "maxNumberOfProblems" = 100;
        "trace.server" = "off";
      };
    };
  };
}
