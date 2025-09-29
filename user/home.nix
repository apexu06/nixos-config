{
  pkgs,
  settings,
  ...
}:
{
  imports = [
    ./stylix.nix
    ./xdg.nix
    ./shells/fish.nix
    ./shells/cli-utils.nix
    (if settings.de == "hyprland" then ./de/hyprland/hyprland.nix else { })
    ./app/neovim/nvim.nix
    ./app/browser/zen.nix
    ./app/vesktop.nix
    ./app/terminal/wezterm.nix
    ./app/git.nix
    ./app/thunderbird.nix
    ./app/shell/quickshell/quickshell.nix
  ];
  home.username = "apexu";
  home.homeDirectory = "/home/apexu";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    protonmail-desktop
    spotifywm
    vlc
    vscode
    devenv
  ];

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "25.05"; # Please read the comment before changing.
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

  programs.home-manager.enable = true;
}
