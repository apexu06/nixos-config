{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.settings.de.shell != "noctalia") {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          ignore_empty_input = true;
          hide_cursor = true;
          disable_loading_bar = true;
          no_fade_out = true;
          fractional_scaling = 1;
        };

        auth = {
          "fingerprint:enabled" = true;
          "fingerprint:ready_message" = "Ready to scan fingerprint";
        };

        background = {
          blur_passes = 2;
          blur_size = 3;
          brightness = 0.65;
        };

        label = [
          {
            text = ''cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"''; # 24H
            color = "$foreground";
            font_size = 94;
            position = "0, 0";
            halign = "center";
            valign = "center";
          }
          {
            text = ''cmd[update:18000000] echo "<b> "$(date +'%A, %-d %B %Y')" </b>"'';
            color = "$color12";
            font_size = 24;
            position = "0, -100";
            halign = "center";
            valign = "center";
          }
          {
            text = "$FPRINTPROMPT";
            position = "0, 400";
            halign = "center";
            valign = "bottom";
          }
        ];

        "input-field" = {
          monitor = "";
          size = "250, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          fade_on_empty = true;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          position = "0, 200";
          halign = "center";
          valign = "bottom";
        };
      };
    };
  };
}
