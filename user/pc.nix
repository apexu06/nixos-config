{pkgs, ...}: {
  home.packages = with pkgs; [
    signal-desktop-bin
    prismlauncher
  ];
  #
  # xdg.desktopEntries."steam" = {
  #   name = "Steam";
  #   genericName = "Steam";
  #   exec = "steam -silent";
  #   icon = "steam";
  #   terminal = false;
  #   categories = ["Game"];
  # };
}
