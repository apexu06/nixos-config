{
  pkgs,
  settings,
  ...
}: {
  imports = [
    ./stylix.nix
    ./xdg.nix
    ./shells/fish.nix
    ./shells/cli-utils.nix
    ./app/neovim/nvim.nix
    ./app/zed/zed.nix
    ./app/browser/firefox.nix
    ./app/desktop.nix
    ./app/spotify.nix

    ./de/${settings.de}/${settings.de}.nix
    ./app/terminal/${settings.terminal}/${settings.terminal}.nix
    ./app/de-shell/${settings.de-shell}/${settings.de-shell}.nix
  ];

  home.username = "apexu";
  home.homeDirectory = "/home/apexu";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    qbittorrent
    osu-lazer-bin
    filezilla
    wine
    winetricks
    lutris
    (discord.override {
      withVencord = true;
    })
  ];

  programs = {
    chromium.enable = true;
    obsidian.enable = true;
    mpv.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "25.05";
  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "fish";
    QT_QPA_PLATFORM = "wayland";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/.nix-profile/share/applications"
  ];

  programs.home-manager.enable = true;
}
