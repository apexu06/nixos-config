{
  pkgs,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    font = {
      name = lib.mkForce "IosevkaTerm Nerd Font Mono";
      size = lib.mkForce 13.5;
    };
    enableGitIntegration = true;
    shellIntegration.enableFishIntegration = true;

    keybindings = {
      "ctrl+j" = "neighboring_window down";
      "ctrl+k" = "neighboring_window up";
      "ctrl+h" = "neighboring_window left";
      "ctrl+l" = "neighboring_window right";

      "ctrl+space>enter" = "new_tab_with_cwd";
      "ctrl+space>e" = "close_window";
      "ctrl+space>h" = "launch --location=hsplit --cwd=current";
      "ctrl+space>v" = "launch --location=vsplit --cwd=current";

      "ctrl+space>1" = "goto_tab 1";
      "ctrl+space>2" = "goto_tab 2";
      "ctrl+space>3" = "goto_tab 3";
      "ctrl+space>4" = "goto_tab 4";
      "ctrl+space>5" = "goto_tab 5";
      "ctrl+space>6" = "goto_tab 6";
      "ctrl+space>7" = "goto_tab 7";
      "ctrl+space>8" = "goto_tab 8";
      "ctrl+space>9" = "goto_tab 9";
    };

    settings = {
      enabled_layouts = "splits";
      scrollback_lines = 80000;
      modify_font = "cell_width 97%";
      window_padding_width = 5;

      tab_bar_edge = "top";
      tab_bar_style = "slant";
      tab_title_max_length = 10;
      tab_title_template = "{index}:{title}";

      confirm_os_window_close = 0;
      # cursor_trail = 1;
      # cursor_trail_decay = "0.1 0.2";
    };
  };
}
