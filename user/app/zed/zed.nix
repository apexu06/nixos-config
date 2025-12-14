{...}: {
  programs.zed-editor = {
    enable = true;
    mutableUserTasks = true;
    mutableUserSettings = true;
    mutableUserKeymaps = true;
    extensions = ["tokyo-night"];
    userKeymaps = [
      {
        context = "(VimControl || !vim_mode || Workspace) && !(vim_mode == insert)";
        bindings = {
          "space s f" = "file_finder::Toggle";
          "space s g" = "pane::DeploySearch";
          "space s b" = "tab_switcher::ToggleAll";
          "space b" = "pane::CloseActiveItem";
          H = "pane::ActivatePreviousItem";
          L = "pane::ActivateNextItem";
          "space t" = "workspace::NewCenterTerminal";
          ctrl-h = "workspace::ActivatePaneLeft";
          ctrl-j = "workspace::ActivatePaneDown";
          ctrl-k = "workspace::ActivatePaneUp";
          ctrl-l = "workspace::ActivatePaneRight";
          "space v" = "pane::SplitVertical";
          "space h" = "pane::SplitHorizontal";
          "space o" = "project_panel::ToggleFocus";
        };
      }
      {
        context = "vim_mode == normal && Editor";
        bindings = {
          "space c a" = "editor::ToggleCodeActions";
          "space r n" = "editor::Rename";
          "space n e" = "editor::GoToDiagnostic";
          "space N e" = "editor::GoToPreviousDiagnostic";
          "space g D" = "editor::GoToDeclaration";
          "space g i" = "editor::GoToImplementation";
        };
      }
      {
        context = "ProjectPanel && not_editing";
        bindings = {
          k = "menu::SelectPrevious";
          j = "menu::SelectNext";
          h = "project_panel::CollapseSelectedEntry";
          l = "project_panel::ExpandSelectedEntry";
          o = "project_panel::Open";
          n = "project_panel::NewFile";
          N = "project_panel::NewDirectory";
          d = "project_panel::Delete";
          r = "project_panel::Rename";
        };
      }
    ];
    # userKeymaps = builtins.readFile ./keymap.json;
    # userSettings = builtins.readFile ./settings.json;
  };

  # home.file.".config/zed/settings.json".text = builtins.readFile ./settings.json;
  # home.file.".config/zed/keymap.json".text = builtins.readFile ./keymap.json;
}
