{pkgs, ...}: {
  home.packages = with pkgs; [
    proton-vpn
    libreoffice-fresh
    brave
    signal-desktop
    qbittorrent
    osu-lazer-bin
    filezilla
    # wine
    # winetricks
    (discord.override {
      withVencord = true;
    })
    nix-update
  ];

  programs = {
    zathura.enable = true;
    chromium.enable = true;
    obsidian.enable = true;
    mpv.enable = true;
    thunderbird = {
      enable = true;
      profiles = {};
    };
  };
}
