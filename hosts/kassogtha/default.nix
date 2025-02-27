{lib, ...}: {
  home = {
    # packages = with pkgs; [];
  };

  wayland.windowManager = let
    output = "eDP-1";
    ultrawide_bg = ../../misc/backgrounds/wallhaven-kxo38d_1920x1080.png;
    resolution = "1920x1080@144.00Hz";
  in {
    sway = {
      config = {
        workspaceOutputAssign = [
          {
            inherit output;
            workspace = "1";
          }
        ];

        output = {
          ${output} = {
            position = "0,0";
            bg = "${ultrawide_bg} fit";
            res = resolution;
          };
        };
      };
    };
    hyprland = {
      settings = {
        monitor = lib.mkForce ["${output},${resolution},auto,1"];
      };
    };
  };
}
