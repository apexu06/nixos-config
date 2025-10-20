{
  pkgs,
  config,
  settings,
  ...
}:

{
  # home.packages = with pkgs; [
  #   quickshell
  # ];

  programs.quickshell = {
    enable = settings.de-shell == "quickshell";
    systemd.enable = true;
    configs = {
      bar = ./quickshell-bar;
    };
    activeConfig = "bar";
  };
}
