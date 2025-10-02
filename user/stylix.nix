{
  pkgs,
  apple-fonts,
  inputs,
  settings,
  lib,
  ...
}:

let
  themeFile = builtins.toPath ../theme/${settings.theme}/theme.yaml;
  wallpaperFile = builtins.replaceStrings [ "\r" ] [ "" ] (
    builtins.readFile ../theme/${settings.theme}/wallpaper.txt
  );
  wallpaperLines = builtins.filter (x: x != "") (lib.splitString "\n" wallpaperFile);

  backgroundUrl = builtins.elemAt wallpaperLines 0;
  backgroundHash = builtins.elemAt wallpaperLines 1;
in
{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  stylix = {
    base16Scheme = themeFile;

    image = pkgs.fetchurl {
      url = backgroundUrl;
      hash = backgroundHash;
    };

    enable = true;
    autoEnable = true;

    targets.font-packages.enable = true;
    targets.fontconfig.enable = true;

    targets.waybar.font = "serif";
    targets.fish.enable = false;

    targets.neovim.plugin = "mini.base16";
    targets.neovim.enable = true;

    targets.qt.enable = true;
    targets.qt.platform = lib.mkForce "qtct";

    targets.zen-browser.profileNames = [ "default" ];

    fonts = {
      serif = {
        package = apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };

      sansSerif = {
        package = apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProDisplay Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetbrainsMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
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
      name = "Catppuccin Mocha Dark";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 32;
    };

  };
}
