{pkgs, ...}: {
  programs.zellij = {
    enable = false;

    attachExistingSession = true;
    enableZshIntegration = true;
    exitShellOnExit = true;

    settings = {
      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };

      keybinds = {
        # Unbind Ctrl+n and Ctrl+p to avoid conflicts with Neovim
        unbind = ["Ctrl n" "Ctrl p"];

        normal = {
          # Use Alt+n and Alt+p for pane navigation instead
          "bind \"Alt n\"" = {NewPane = [];};
          "bind \"Alt p\"" = {SwitchToMode = "Pane";};
        };
      };
    };

    layouts = {
      default = ''
         layout {
             default_tab_template {
               pane size=1 borderless=true {
                   plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                       format_left   "#[fg=#89B4FA,bold]{command_hostname} {mode}"
                       format_center "{tabs}"
                       format_right  "{datetime}"
                       format_space  ""

                       border_enabled  "false"
                       border_char     "─"
                       border_format   "#[fg=#6C7086]{char}"
                       border_position "bottom"
                       hide_frame_for_single_pane "false"

                       command_hostname_command "hostname -s"
                       command_hostname_format "{stdout}"
                       command_hostname_interval "60"
                       command_hostname_rendermode "static"

                       mode_normal        "#[fg=#A6E3A1] NORMAL"
                       mode_locked        "#[fg=#FAB387] LOCKED"
                       mode_resize        "#[fg=#F9E2AF] RESIZE"
                       mode_pane          "#[fg=#CBA6F7] PANE"
                       mode_tab           "#[fg=#89B4FA] TAB"
                       mode_scroll        "#[fg=#F38BA8] SCROLL"
                       mode_enter_search  "#[fg=#F9E2AF] SEARCH"
                       mode_search        "#[fg=#F9E2AF] SEARCH"
                       mode_rename_tab    "#[fg=#89B4FA] RENAME_TAB"
                       mode_rename_pane   "#[fg=#CBA6F7] RENAME_PANE"
                       mode_session       "#[fg=#F5C2E7] SESSION"
                       mode_move          "#[fg=#F5E0DC] MOVE"
                       mode_prompt        "#[fg=#94E2D5] PROMPT"
                       mode_tmux          "#[fg=#FAE3B0] TMUX"

                       tab_normal   "#[fg=#6C7086] {name} "
                       tab_active   "#[fg=#9399B2,bold,italic] {name} "

                       datetime        "#[fg=#6C7086,bold] {format} "
                       datetime_format "%Y-%m-%d %R"
                       datetime_timezone "America/New_York"
                  }
                }
               children
               pane size=1 borderless=true {
                   plugin location="zellij:status-bar"
               }
            }
        }'';
    };
  };
}
