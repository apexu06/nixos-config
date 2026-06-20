{pkgs, ...}: {
  home.sessionVariables = {
    TERM_CMD = "wezterm";
  };

  home.packages = with pkgs; [
    wezterm
    nerd-fonts.iosevka-term
  ];

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
