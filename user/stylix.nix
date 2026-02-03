{
  pkgs,
  inputs,
  settings,
  lib,
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
    inputs.stylix.homeModules.stylix
    inputs.niri.homeModules.stylix
  ];

  stylix =
    {
      enable = true;
      autoEnable = true;

      base16Scheme = themeFile;

      targets.waybar.font = "serif";
      targets.fish.enable = false;
      targets.zed.enable = false;

      targets.qt = {
        enable = true;
        standardDialogs = "xdgdesktopportal";
      };

      targets.neovim = {
        plugin = "mini.base16";
        enable = false;
        transparentBackground = {
          numberLine = true;
          main = true;
          signColumn = true;
        };
      };

      targets.zen-browser.profileNames = ["default"];

      targets.obsidian.vaultNames = [
        "red-cross"
        "personal"
      ];

      fonts = {
        serif = {
          package = pkgs.rubik;
          name = "Rubik";
        };

        sansSerif = {
          package = pkgs.rubik;
          name = "Rubik";
        };

        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetbrainsMono Nerd Font";
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

      icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };

      cursor = {
        name = "Catppuccin Mocha Light";
        package = pkgs.catppuccin-cursors.mochaLight;
        size = 32;
      };
    }
    // lib.optionalAttrs (settings.useWallpaper) {
      image = pkgs.fetchurl {
        url = backgroundUrl;
        hash = backgroundHash;
      };
    };
}
