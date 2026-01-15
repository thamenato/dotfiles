{pkgs, ...}: {
  programs.helix = {
    enable = true;

    settings = {
      editor = {
        line-number = "relative";
      };
    };

    languages = {
      language-server.codebook = {
        command = "${pkgs.codebook}/bin/codebook-lsp";
        args = ["serve"];
      };

      language = [
        {
          name = "bash";
          auto-format = true;
        }
        {
          name = "cue";
          auto-format = true;
        }
        {
          name = "go";
          auto-format = true;
        }
        {
          name = "hcl";
          auto-format = true;
        }
        {
          name = "html";
          auto-format = true;
        }
        {
          name = "markdown";
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "alejandra";
          };
        }
        {
          name = "python";
          auto-format = true;
        }
      ];
    };
  };
}
