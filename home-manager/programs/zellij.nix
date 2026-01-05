{
  programs.zellij = {
    enable = true;

    attachExistingSession = true;
    enableZshIntegration = true;
    exitShellOnExit = false;

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
              plugin location="https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm" {
                // pine rose theme
                color_base "#232136"
                color_surface "#2a273f"
                color_overlay "#393552"
                color_muted "#6e6a86"
                color_subtle "#908caa"
                color_text "#e0def4"
                color_love "#eb6f92"
                color_gold "#f6c177"
                color_rose "#ea9a97"
                color_pine "#3e8fb0"
                color_foam "#9ccfd8"
                color_Iris "#c4a7e7"
                color_highlight_low "#2a283e"
                color_highlight_med "#44415a"
                color_highlight_high "#56526e"

                format_left   "{tabs}"
                format_center "#[fg=$text] {mode}#[]"
                format_right  " {command_host}  {session} "
                format_space  ""

                border_enabled  "false"
                border_char     "─"
                border_format   "#[fg=$base]{char}"
                border_position "top"

                hide_frame_for_single_pane "false"

                mode_normal        "#[fg=$text] NORMAL "
                mode_locked        "#[fg=$muted] LOCKED "
                mode_pane          "#[fg=$pine,bold] PANE "
                mode_tab           "#[fg=$rose,bold] TAB "
                mode_scroll        "#[fg=$foam,bold] SCROLL "
                mode_enter_search  "#[fg=$text,bold] ENT-SEARCH "
                mode_search        "#[fg=$subtle,bold] SEARCH "
                mode_resize        "#[fg=$gold,bold] RESIZE "
                mode_rename_tab    "#[fg=$gold,bold] RENAME TAB "
                mode_rename_pane   "#[fg=$gold,bold] RENAME PANE "
                mode_move          "#[fg=$gold,bold] MOVE "
                mode_session       "#[fg=$love,bold] SESSION "
                mode_prompt        "#[fg=$love,bold] PROMPT "

                tab_normal              "#[fg=$subtle]  {index} #[fg=$subtle]{floating_indicator} "
                tab_normal_fullscreen   "#[fg=$subtle]  {index} #[fg=$subtle]{fullscreen_indicator} "
                tab_normal_sync         "#[fg=$subtle]  {index} #[fg=$subtle]{sync_indicator} "
                tab_active              "#[bg=$overlay,fg=$text]  {index} #[bg=$overlay,fg=$text,bold]{floating_indicator} "
                tab_active_fullscreen   "#[bg=$overlay,fg=$text]  {index} #[bg=$overlay,fg=$text,bold]{fullscreen_indicator} "
                tab_active_sync         "#[bg=$overlay,fg=$text]  {index} #[bg=$overlay,fg=$text,bold]{sync_indicator} "
                tab_separator           " "

                tab_sync_indicator       ""
                tab_fullscreen_indicator "󰊓"
                tab_floating_indicator   "󰹙"

                command_host_command    "uname -n"
                command_host_format     "{stdout}"
                command_host_interval   "0"
                command_host_rendermode "static"

                datetime        "#[fg=$base,bold] {format} "
                datetime_format "%A, %d %b %Y %H:%M"
                datetime_timezone "America/New_York"
              }
           }
           children
           }
        }'';
    };
  };
}
