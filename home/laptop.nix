{}: {
  imports = [
    ../modules/home/git.nix
    ../modules/home/stylix.nix
    ../modules/home/xdg.nix

    ../modules/home/de/niri
    ../modules/home/de/shell/noctalia

    ../modules/home/app/browser/firefox.nix
    ../modules/home/app/terminal/kitty
    ../modules/home/app/neovim
    ../modules/home/app/gui-apps.nix
    ../modules/home/app/spotify.nix
  ];
}
