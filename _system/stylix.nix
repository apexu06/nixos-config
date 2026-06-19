{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  themePath = ../theme/${config.settings.theme}/theme.yaml;
  themeFile = builtins.toPath themePath;
  wallpaperFile = builtins.replaceStrings ["\r"] [""] (
    builtins.readFile ../theme/${config.settings.theme}/wallpaper.txt
  );
  wallpaperLines = builtins.filter (x: x != "") (lib.splitString "\n" wallpaperFile);
  localWallpaper = ../theme/${config.settings.theme}/wallpaper.jpg;
  hasLocalWallpaper = builtins.pathExists localWallpaper;

  backgroundUrl = builtins.elemAt wallpaperLines 0;
  backgroundHash = builtins.elemAt wallpaperLines 1;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix =
    {
      enable = true;
      autoEnable = false;

      targets = {
        gtk.enable = true;
      };

      base16Scheme = themeFile;

      fonts = {
        serif = {
          package = pkgs.adwaita-fonts;
          name = "Adwaita Sans";
        };

        sansSerif = {
          package = pkgs.adwaita-fonts;
          name = "Adwaita Sans";
        };

        monospace = {
          package = pkgs.adwaita-fonts;
          name = "Adwaita Mono";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = 13;
          desktop = 14;
        };
      };
    }
    // lib.optionalAttrs (config.settings.de.useWallpaper) {
      image =
        if hasLocalWallpaper
        then localWallpaper
        else
          pkgs.fetchurl {
            url = backgroundUrl;
            hash = backgroundHash;
          };
    };
}
