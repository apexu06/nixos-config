{
  pkgs,
  apple-fonts,
  inputs,
  ...
}:

{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/5y/wallhaven-5y7g79.jpg";
      hash = "sha256-QNfvxIWgJcv6r5HeCd2oUlZzDPccV2GEdBnQcrf0Ufg=";
    };

    enable = true;
    autoEnable = true;

    targets.font-packages.enable = true;
    targets.fontconfig.enable = true;

    targets.waybar.font = "serif";
    targets.fish.enable = false;

    targets.neovim.plugin = "mini.base16";
    targets.neovim.enable = true;

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
    };
  };

}
