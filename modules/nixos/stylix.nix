{
  inputs,
  theme,
  pkgs,
  lib,
  ...
}: let
  themeFile = builtins.toPath ../../theme/${theme}/theme.yaml;
  wallpaperFile = builtins.replaceStrings ["\r"] [""] (
    builtins.readFile ../../theme/${theme}/wallpaper.txt
  );
  wallpaperLines = builtins.filter (x: x != "") (lib.splitString "\n" wallpaperFile);
  localWallpaper = ../../theme/${theme}/wallpaper.jpg;
  hasLocalWallpaper = builtins.pathExists localWallpaper;

  backgroundUrl = builtins.elemAt wallpaperLines 0;
  backgroundHash = builtins.elemAt wallpaperLines 1;
in {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "kvantum";
  };

  stylix = {
    enable = true;
    autoEnable = false;

    targets = {
      gtk.enable = true;
      qt.enable = true;
    };

    base16Scheme = themeFile;

    image =
      if hasLocalWallpaper
      then localWallpaper
      else
        pkgs.fetchurl {
          url = backgroundUrl;
          hash = backgroundHash;
        };

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
  };
}
