{
  pkgs,
  settings,
  inputs,
  ...
}: {
  imports = [
    ./stylix.nix
    ./xdg.nix
    ./shells/fish.nix
    ./shells/cli-utils.nix
    ./de/${settings.de}/${settings.de}.nix
    ./app/neovim/nvim.nix
    ./app/browser/zen.nix
    ./app/terminal/wezterm.nix
    ./app/shell/quickshell/quickshell.nix
    ./app/desktop.nix
    ./app/spotify.nix
  ];
  home.username = "apexu";
  home.homeDirectory = "/home/apexu";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    vlc
    obsidian
    qbittorrent
  ];

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "25.05";
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
