{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wezterm
    nerd-fonts.iosevka-term
  ];

  programs.wezterm = {
    enable = true;
  };

  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
}
