{ pkgs, ... }:
{
  imports = [
    ./stylix.nix
    ./shells/fish.nix
    ./shells/cli-utils.nix
    ./wm/hyprland/hyprland.nix
    ./app/neovim/nvim.nix
    ./app/browser/zen.nix
    ./app/vesktop.nix
    ./app/terminal/wezterm.nix
    ./app/git.nix
  ];
  home.username = "apexu";
  home.homeDirectory = "/home/apexu";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    spotify
    vlc
    vscode
  ];

  xdg.desktopEntries = {
    yazi = {
      name = "Yazi";
      noDisplay = true;
    };
    btop = {
      name = "btop++";
      noDisplay = true;
    };
    fish = {
      name = "fish";
      noDisplay = true;
    };
    vim = {
      name = "Vim";
      noDisplay = true;
    };
    gvim = {
      name = "GVim";
      noDisplay = true;
    };
    nvim = {
      name = "nvim";
      noDisplay = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  home.stateVersion = "25.05"; # Please read the comment before changing.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/.nix-profile/share/applications"
  ];

  programs.home-manager.enable = true;
}
