{ pkgs, ... }:
{
  # home.packages = with pkgs; [
  #   quickshell
  # ];
  programs.quickshell = {
    enable = true;
    configs = {
      bar = ./quickshell-bar;
    };
    activeConfig = "bar";
  };
}
