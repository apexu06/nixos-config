{ config, lib, ... }:
{
  programs.tofi = {
    enable = true;
    settings = {
      font = lib.mkForce config.stylix.fonts.serif.name;

      result-spacing = "10";

      width = "30%";
      height = "32";
      outline-width = "0";
      border-width = "0";
      horizontal = "true";
      background-color = lib.mkForce "#00000066";
      input-background = lib.mkForce "#00000000";
      prompt-background = lib.mkForce "#00000000";
      selection-background = lib.mkForce "#00000000";
      default-result-background = lib.mkForce "#00000000";
      selection-color = lib.mkForce config.lib.stylix.colors.base0D;
      padding-top = "0";
      padding-bottom = "2";
      corner-radius = "12";

      anchor = "top";
      margin-top = "8";

      text-cursor = "true";
    };
  };
}
