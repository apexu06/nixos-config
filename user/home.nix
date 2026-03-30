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
    ./app/rider/rider.nix
    ./app/browser/firefox.nix
    ./app/desktop.nix
    ./app/spotify.nix
    ./distrobox.nix

    ./de/${settings.de}/${settings.de}.nix
    ./app/terminal/${settings.terminal}/${settings.terminal}.nix
    ./app/de-shell/${settings.de-shell}/${settings.de-shell}.nix
  ];

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    qbittorrent
    osu-lazer-bin
    filezilla
    wine
    winetricks
    (discord.override {
      withVencord = true;
    })
    nix-update
  ];

  programs = {
    chromium.enable = true;
    obsidian.enable = true;
    mpv.enable = true;
  };

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

  home = {
    username = "apexu";
    homeDirectory = "/home/apexu";
    stateVersion = "25.05";
  };

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
