{
  pkgs,
  lib,
  ...
}: let
  krisp-patcher =
    pkgs.writers.writePython3Bin "krisp-patcher"
    {
      libraries = with pkgs.python3Packages; [
        capstone
        pyelftools
      ];
      flakeIgnore = [
        "E501" # line too long (82 > 79 characters)
        "F403" # 'from module import *' used; unable to detect undefined names
        "F405" # name may be undefined, or defined from star imports: module
      ];
    }
    (
      builtins.readFile (
        pkgs.fetchurl {
          url = "https://pastebin.com/raw/8tQDsMVd";
          sha256 = "sha256-IdXv0MfRG1/1pAAwHLS2+1NESFEz2uXrbSdvU9OvdJ8=";
        }
      )
    );
in {
  imports = [
    ../modules/home/git.nix
    ../modules/home/distrobox.nix
    ../modules/home/stylix.nix
    ../modules/home/xdg.nix

    ../modules/home/de/niri
    ../modules/home/de/shell/noctalia

    ../modules/home/app/browser/firefox.nix
    ../modules/home/app/terminal/kitty
    ../modules/home/app/neovim
    ../modules/home/app/gui-apps.nix
    ../modules/home/app/spotify.nix
    ../modules/home/app/gpu-screen-recorder.nix
  ];

  nixpkgs.overlays = [
    (_: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
    })
  ];

  home.packages = [
    pkgs.prismlauncher
    krisp-patcher
  ];

  stylix.fonts.sizes.terminal = lib.mkForce 13;
}
