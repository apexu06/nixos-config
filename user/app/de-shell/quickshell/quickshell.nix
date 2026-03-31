{
  pkgs,
  lib,
  config,
  settings,
  ...
}: {
  config = lib.mkIf (config.settings.de-shell == "quickshell") {
    home.packages = with pkgs; [
      material-symbols
      cava
      libnotify
    ];

    programs.quickshell = {
      enable = settings.de-shell == "quickshell";
      systemd.enable = true;
      configs = {
        bar = ./quickshell-bar;
      };
      activeConfig = "bar";
    };

    home.activation.wallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.systemd}/bin/systemctl --user restart quickshell.service
    '';

    systemd.user.services.quickshell = {
      Service = {
        Environment = [
          "SHELL=/run/current-system/sw/bin/fish"
        ];
      };
    };
  };
}
