{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nerd-fonts.iosevka-term
  ];

  imports = [
    ../tmux.nix
  ];

  programs.foot = {
    enable = true;

    settings = {
      main = {
        font = lib.mkForce "IosevkaTerm Nerd Font:size=13";
        pad = "8x8";
      };
      scrollback = {
        lines = 80000;
      };
    };
  };
}
