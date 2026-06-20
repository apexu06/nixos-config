{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../tmux.nix
  ];

  home.packages = with pkgs; [
    nerd-fonts.iosevka-term
  ];

  home.sessionVariables = {
    TERM_CMD = "foot";
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = lib.mkDefault "IosevkaTerm Nerd Font:size=13:weight=Medium";
        font-bold = lib.mkDefault "IosevkaTerm Nerd Font:size=13:weight=SemiBold";
        pad = "8x8";
      };
      scrollback = {
        lines = 80000;
      };
    };
  };
}
