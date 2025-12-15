{
  pkgs,
  settings,
  ...
}: {
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

  systemd.user.services.quickshell = {
    Service = {
      Environment = [
        "SHELL=/run/current-system/sw/bin/fish"
      ];
    };
  };
}
