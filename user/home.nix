{ config, pkgs, ... }:

{
  imports = [
    ./shells/fish.nix
    ./shells/cli-utils.nix
    ./wm/hyprland/hyprland.nix
    ./app/neovim/nvim.nix
    ./app/terminal/wezterm.nix
    ./app/git.nix
  ];

  home.username = "apexu";
  home.homeDirectory = "/home/apexu";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.sessionVariables = {
     EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
