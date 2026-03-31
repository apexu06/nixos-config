{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../tmux.nix
  ];

  config = lib.mkIf (config.settings.terminal.emulator == "foot") {
    home.packages = with pkgs; [
      nerd-fonts.iosevka-term
    ];

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
  };
}
