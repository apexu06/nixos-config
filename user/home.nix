{...}: {
  imports = [
    ./stylix.nix
    ./xdg.nix
    ./shells/fish.nix
    ./shells/cli-utils.nix
    ./app/neovim/nvim.nix
    ./app/browser/firefox.nix
    ./app/apps.nix
    ./app/spotify.nix
    ./distrobox.nix

    ./de/hyprland/hyprland.nix
    ./de/niri/niri.nix
    ./de/mangowc/mangowc.nix
    ./de/kde/kde.nix

    ./app/terminal/foot/foot.nix
    ./app/terminal/wezterm/wezterm.nix
    ./app/terminal/kitty/kitty.nix

    ./app/de-shell/noctalia/noctalia.nix
    ./app/de-shell/dms/dms.nix
    ./app/de-shell/quickshell/quickshell.nix
    ./app/de-shell/ags/ags.nix
  ];

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "fish";
    QT_QPA_PLATFORM = "wayland";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/.nix-profile/share/applications"
  ];

  home = {
    username = "apexu";
    homeDirectory = "/home/apexu";
    stateVersion = "26.05";
  };

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
