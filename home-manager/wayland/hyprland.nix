{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = let
      modifier = "SUPER";
      terminal = "${pkgs.ghostty}/bin/ghostty";
      menu = "${pkgs.rofi}/bin/rofi -show drun";
    in {
      "$mod" = "${modifier}";

      env = [
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      ];

      exec-once = [
        "systemctl --user start hyprpolkitagent"
        "systemctl --user enable --now hyprpaper.service"
        "waybar"
      ];

      monitor = [
        ",preferred,auto,auto"
      ];

      general = {
        # https://wiki.hyprland.org/Configuring/Variables/#general
        gaps_in = 5;
        # gaps_out = 20;
        gaps_out = 10;
        border_size = 2;
        # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        rounding = 0;

        # Change transparency of focused and unfocused windows
        active_opacity = 1.0;
        inactive_opacity = 1.0;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };

        blur = {
          # https://wiki.hyprland.org/Configuring/Variables/#blur
          enabled = true;
          size = 3;
          passes = 1;

          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      input = {
        # https://wiki.hyprland.org/Configuring/Variables/#input
        kb_layout = "us";
        kb_variant = "intl";

        follow_mouse = 1;
        sensitivity = 0; # 0 means no modification.
        touchpad = {
          natural_scroll = false;
        };
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        # https://wiki.hyprland.org/Configuring/Variables/#misc
        force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
      };

      gestures = {
        # https://wiki.hyprland.org/Configuring/Variables/#gestures
        workspace_swipe = false;
      };

      bind =
        [
          "$mod, d, exec, ${menu}"
          "$mod, q, killactive,"
          "ctrl alt, delete, exit,"
          "ctrl alt, l, exec, hyprlock"
          "$mod, return, exec, ${terminal}"
          ", Print, exec, grimblast copy area"

          # window modes
          "$mod, f, fullscreen,"
          "$mod shift, space, togglefloating,"

          # move focus
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          # move window
          "$mod shift, left, movewindow, l"
          "$mod shift, right, movewindow, r"
          "$mod shift, up, movewindow, u"
          "$mod shift, down, movewindow, d"
          "$mod shift, h, movewindow, l"
          "$mod shift, l, movewindow, r"
          "$mod shift, k, movewindow, u"
          "$mod shift, j, movewindow, d"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i: let
                ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9
          )
        );

      # mouse movements
      bindm = [
        # Left Mouse Button
        "$mod, mouse:272, movewindow"
        # Right Mouse Button
        "$mod, mouse:273, resizewindow"
      ];

      # media controls - requires playerctl
      bindl = [
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"

        # volume
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      # laptop multimedia keys
      bindel = let
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      in [
        # volume
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 5%-"

        # backlight
        ", XF86MonBrightnessUp, exec, ${brightnessctl} s 10%+"
        ", XF86MonBrightnessDown, exec, ${brightnessctl} s 10%-"
      ];
    };
  };
}
