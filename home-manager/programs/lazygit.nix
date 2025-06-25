{
  programs.lazygit = let
    # dracula = {
    #   # https://github.com/dracula/lazygit/blob/main/config/dracula.yml
    #   theme = {
    #     "activeBorderColor" = [
    #       "#FF79C6"
    #       "bold"
    #     ];
    #     "inactiveBorderColor" = ["#BD93F9"];
    #     "searchingActiveBorderColor" = [
    #       "#8BE9FD"
    #       "bold"
    #     ];
    #     "optionsTextColor" = ["#6272A4"];
    #     "selectedLineBgColor" = ["#6272A4"];
    #     "inactiveViewSelectedLineBgColor" = ["bold"];
    #     "cherryPickedCommitFgColor" = ["#6272A4"];
    #     "cherryPickedCommitBgColor" = ["#8BE9FD"];
    #     "markedBaseCommitFgColor" = ["#8BE9FD"];
    #     "markedBaseCommitBgColor" = ["#F1FA8C"];
    #     "unstagedChangesColor" = ["#FF5555"];
    #     "defaultFgColor" = ["#F8F8F2"];
    #   };
    # };
    cyberdream = {
      # https://github.com/scottmckendry/cyberdream.nvim/blob/main/extras/lazygit/cyberdream.yml
      border = "rounded";
      theme = {
        "activeBorderColor" = ["#5ef1ff"];
        "inactiveBorderColor" = ["#7b8496"];
        "searchingActiveBorderColor" = ["#ff5ef1"];
        "optionsTextColor" = ["#3c4048"];
        "selectedLineBgColor" = ["#3c4048"];
        "cherryPickedCommitBgColor" = ["#3c4048"];
        "cherryPickedCommitFgColor" = ["#ff5ea0"];
        "unstagedChangesColor" = ["#ffbd5e"];
        "defaultFgColor" = ["#ffffff"];
      };
    };
  in {
    enable = true;
    settings = {
      git = {
        overrideGpg = true;
      };

      gui = cyberdream;
    };
  };
}
