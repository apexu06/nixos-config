{
  pkgs,
  settings,
  ...
}: {
  home.packages = with pkgs; [
    material-symbols
  ];

  programs.quickshell = {
    enable = settings.de-shell == "quickshell";
    systemd.enable = true;
    configs = {
      bar = ./quickshell-bar;
    };
    activeConfig = "bar";
  };
}
