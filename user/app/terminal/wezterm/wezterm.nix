{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.settings.terminal.emulator == "wezterm") {
    home.packages = with pkgs; [
      wezterm
      nerd-fonts.iosevka-term
    ];

    programs.wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
