{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.settings.de.launcher == "fuzzel") {
    home.packages = with pkgs; [
      fuzzel
    ];

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          width = 60;
          lines = 6;
          line-height = 36;
          anchor = "top";
          y-margin = 20;
          inner-pad = 10;
          prompt = "  ";
          hide-before-typing = false;
          font = lib.mkForce (config.stylix.fonts.serif.name + ":size=14");
          scaling-filter = "lanczos-3";
        };

        border = {
          radius = 10;
          selection-radius = 5;
          width = 2;
        };
      };
    };
  };
}
