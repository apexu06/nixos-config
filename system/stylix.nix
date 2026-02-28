{
  inputs,
  settings,
  lib,
  pkgs,
  ...
}: let
  themePath = ../theme/${settings.theme}/theme.yaml;
  themeFile = builtins.toPath themePath;
  wallpaperFile = builtins.replaceStrings ["\r"] [""] (
    builtins.readFile ../theme/${settings.theme}/wallpaper.txt
  );
  wallpaperLines = builtins.filter (x: x != "") (lib.splitString "\n" wallpaperFile);

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
        console.enable = true;
      };

      base16Scheme = themeFile;
    }
    // lib.optionalAttrs (settings.useWallpaper) {
      image = pkgs.fetchurl {
        url = backgroundUrl;
        hash = backgroundHash;
      };
    };
}
