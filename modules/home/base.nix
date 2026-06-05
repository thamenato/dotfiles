# modules/home/base.nix
# Base homeModule that all hosts inherit from
{self, ...}: {
  flake.homeModules.base = {...}: {
    imports = [
      # Core modules
      self.homeModules.packages
      self.homeModules.stylix
      self.homeModules.dconf
      self.homeModules.gtk
      self.homeModules.qt

      # All programs
      self.homeModules."programs/alacritty"
      self.homeModules."programs/atuin"
      self.homeModules."programs/bat"
      self.homeModules."programs/btop"
      self.homeModules."programs/claude-code"
      self.homeModules."programs/direnv"
      self.homeModules."programs/eza"
      self.homeModules."programs/fd"
      self.homeModules."programs/fzf"
      self.homeModules."programs/gh-dash"
      self.homeModules."programs/gh"
      self.homeModules."programs/ghostty"
      self.homeModules."programs/git"
      self.homeModules."programs/go"
      self.homeModules."programs/helix"
      self.homeModules."programs/hyprlock"
      self.homeModules."programs/k9s"
      self.homeModules."programs/kitty"
      self.homeModules."programs/lazygit"
      self.homeModules."programs/mergiraf"
      self.homeModules."programs/ncspot"
      self.homeModules."programs/nh"
      self.homeModules."programs/noctalia"
      self.homeModules."programs/nvf"
      self.homeModules."programs/opencode"
      self.homeModules."programs/ripgrep"
      self.homeModules."programs/rofi"
      self.homeModules."programs/ruff"
      self.homeModules."programs/swaylock"
      self.homeModules."programs/taskwarrior"
      self.homeModules."programs/tmux"
      self.homeModules."programs/vscode"
      self.homeModules."programs/waybar"
      self.homeModules."programs/yazi"
      self.homeModules."programs/zellij"
      self.homeModules."programs/zen"
      self.homeModules."programs/zoxide"
      self.homeModules."programs/zsh"

      # Services
      self.homeModules."services/easyeffects"
      self.homeModules."services/mako"
      self.homeModules."services/swayidle"

      # Wayland
      self.homeModules."wayland/hyprland"
      self.homeModules."wayland/niri"
      self.homeModules."wayland/sway"
    ];

    home = {
      username = "thamenato";
      homeDirectory = "/home/thamenato";

      shellAliases = {
        lg = "lazygit";
        man = "batman";
      };

      sessionVariables = {
        EDITOR = "nvim";
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        OZONE_PLATFORM = "wayland";
        GDK_BACKEND = "wayland";
      };
    };

    fonts.fontconfig.enable = true;

    home.stateVersion = "22.11";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
}
