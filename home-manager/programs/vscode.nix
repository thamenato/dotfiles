{pkgs, ...}: {
  programs.vscode = {
    enable = false;

    # do not let VSCode alter the folder, only Home-Manager
    mutableExtensionsDir = false;

    profiles.default = {
      # disable checking for remote updates
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;

      extensions = with pkgs.vscode-extensions; [
        adpyke.codesnap
        astro-build.astro-vscode
        bierner.emojisense
        charliermarsh.ruff
        codezombiech.gitignore
        github.vscode-github-actions
        hashicorp.hcl
        hashicorp.terraform
        james-yu.latex-workshop
        jdinhlife.gruvbox
        jnoortheen.nix-ide
        mikestead.dotenv
        mkhl.direnv
        # ms-python.debugpy
        # ms-python.python
        ms-vscode-remote.remote-containers
        nefrob.vscode-just-syntax
        redhat.ansible
        redhat.vscode-yaml
        # rust-lang.rust-analyzer
        streetsidesoftware.code-spell-checker
        sumneko.lua
        tamasfe.even-better-toml
        timonwong.shellcheck
        vadimcn.vscode-lldb
        vscode-icons-team.vscode-icons
        vscodevim.vim
        waderyan.gitblame
        yzhang.markdown-all-in-one
      ];

      userSettings = {
        # ui
        "window.menuBarVisibility" = "toggle";
        "workbench.colorTheme" = "Gruvbox Dark Medium";
        "workbench.iconTheme" = "vscode-icons";

        # editor
        "editor.rulers" = [
          80
          120
        ];
        "editor.fontFamily" = "'JetBrainsMono NF', 'monospace'";
        "editor.fontLigatures" = true;
        "editor.formatOnSave" = true;
        "editor.inlineSuggest.enabled" = true;
        "editor.codeActionsOnSave" = {
          "source.organizeImports.ruff" = "explicit";
        };

        # languages
        "[terraform]" = {
          "editor.tabSize" = 2;
        };
        "[python]" = {
          "editor.defaultFormatter" = "charliermarsh.ruff";
        };
        "[github-actions-workflow]" = {
          "editor.tabSize" = 2;
        };
        "[markdown]" = {
          "editor.defaultFormatter" = "yzhang.markdown-all-in-one";
        };
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.formatterPath" = "nixfmt";
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = {
              "command" = ["nixfmt"];
            };
          };
        };

        # extensions
        "codesnap.realLineNumbers" = true;
        "codesnap.showWindowControls" = false;
        "codesnap.showWindowTitle" = true;
        "codesnap.transparentBackground" = true;

        "git.inputValidationLength" = 72;
        "git.inputValidationSubjectLength" = 50;
        "[git-commit]" = {
          "editor.rulers" = [
            72
            50
          ];
          "editor.wordWrap" = "off";
          "workbench.editor.restoreViewState" = false;
        };

        "terraform.languageServer" = {
          "maxNumberOfProblems" = 100;
          "trace.server" = "off";
        };
      };
    };
  };
}
