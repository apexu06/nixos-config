{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    quickshell
  ];

  # xdg.configFile."quickshell/bar".source = ./quickshell-bar;

  # xdg.configFile."quickshell/bar/Theme.qml".text = ''
  #   pragma Singleton
  #   import QtQuick
  #   QtObject {
  #     // Base16
  #     property color base00: "#${config.lib.stylix.colors.base00}"
  #     property color base01: "#${config.lib.stylix.colors.base01}"
  #     property color base02: "#${config.lib.stylix.colors.base02}"
  #     property color base03: "#${config.lib.stylix.colors.base03}"
  #     property color base04: "#${config.lib.stylix.colors.base04}"
  #     property color base05: "#${config.lib.stylix.colors.base05}"
  #     property color base06: "#${config.lib.stylix.colors.base06}"
  #     property color base07: "#${config.lib.stylix.colors.base07}"
  #     property color base08: "#${config.lib.stylix.colors.base08}"
  #     property color base09: "#${config.lib.stylix.colors.base09}"
  #     property color base0A: "#${config.lib.stylix.colors.base0A}"
  #     property color base0B: "#${config.lib.stylix.colors.base0B}"
  #     property color base0C: "#${config.lib.stylix.colors.base0C}"
  #     property color base0D: "#${config.lib.stylix.colors.base0D}"
  #     property color base0E: "#${config.lib.stylix.colors.base0E}"
  #     property color base0F: "#${config.lib.stylix.colors.base0F}"
  #     // Aliases
  #     property color base: base00
  #     property color mantle: base01
  #     property color surface0: base02
  #     property color surface1: base03
  #     property color surface2: base04
  #     property color text: base05
  #     property color rosewater: base06
  #     property color lavender: base07
  #     property color red: base08
  #     property color peach: base09
  #     property color yellow: base0A
  #     property color green: base0B
  #     property color teal: base0C
  #     property color blue: base0D
  #     property color mauve: base0E
  #     property color flamingo: base0F
  #     property color background: base00
  #     property color backgroundAlt: base01
  #     property color selection: base02
  #     property color textAlt: base04
  #     property color warning: base0A
  #     property color urgent: base09
  #     property color error: base08
  #   }
  #
  # '';

  # xdg.configFile."quickshell/bar".source = pkgs.runCommand "quickshell-bar" { } ''
  #     mkdir -p $out
  #     cp -r ${./quickshell-bar}/* $out/
  #     cat > $out/Theme.qml <<EOF
  #       pragma Singleton
  #       import QtQuick
  #       QtObject {
  #         // Base16
  #         property color base00: "#${config.lib.stylix.colors.base00}"
  #         property color base01: "#${config.lib.stylix.colors.base01}"
  #         property color base02: "#${config.lib.stylix.colors.base02}"
  #         property color base03: "#${config.lib.stylix.colors.base03}"
  #         property color base04: "#${config.lib.stylix.colors.base04}"
  #         property color base05: "#${config.lib.stylix.colors.base05}"
  #         property color base06: "#${config.lib.stylix.colors.base06}"
  #         property color base07: "#${config.lib.stylix.colors.base07}"
  #         property color base08: "#${config.lib.stylix.colors.base08}"
  #         property color base09: "#${config.lib.stylix.colors.base09}"
  #         property color base0A: "#${config.lib.stylix.colors.base0A}"
  #         property color base0B: "#${config.lib.stylix.colors.base0B}"
  #         property color base0C: "#${config.lib.stylix.colors.base0C}"
  #         property color base0D: "#${config.lib.stylix.colors.base0D}"
  #         property color base0E: "#${config.lib.stylix.colors.base0E}"
  #         property color base0F: "#${config.lib.stylix.colors.base0F}"
  #         // Aliases
  #         property color base: base00
  #         property color mantle: base01
  #         property color surface0: base02
  #         property color surface1: base03
  #         property color surface2: base04
  #         property color text: base05
  #         property color rosewater: base06
  #         property color lavender: base07
  #         property color red: base08
  #         property color peach: base09
  #         property color yellow: base0A
  #         property color green: base0B
  #         property color teal: base0C
  #         property color blue: base0D
  #         property color mauve: base0E
  #         property color flamingo: base0F
  #         property color background: base00
  #         property color backgroundAlt: base01
  #         property color selection: base02
  #         property color textAlt: base04
  #         property color warning: base0A
  #         property color urgent: base09
  #         property color error: base08
  #       }
  #   EOF
  # '';
  #
  # programs.quickshell = {
  #   enable = true;
  #   configs = {
  #     bar = ./quickshell-bar;
  #   };
  #   activeConfig = "bar";
  # };
}
