{
  pkgs,
  settings,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    signal-desktop-bin
    teamspeak6-client
  ];
}
