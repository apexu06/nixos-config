{
  pkgs,
  config,
  ...
}: let
  colors = config.lib.stylix.colors;
in {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    escapeTime = 0;
    prefix = "C-Space";
    sensibleOnTop = true;

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.dotbar;
        extraConfig = ''
          set -g @tmux-dotbar-right true
          set -g @tmux-dotbar-position top

          set -g @tmux-dotbar-bg "#${colors.base01}"
          set -g @tmux-dotbar-fg "#${colors.base04}"
          set -g @tmux-dotbar-fg-current "#${colors.base0D}"
          set -g @tmux-dotbar-fg-session "#${colors.base04}"
          set -g @tmux-dotbar-fg-prefix "#${colors.base0D}"
        '';
      }
    ];

    extraConfig = ''
      bind-key -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h'  'select-pane -L'
      bind-key -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j'  'select-pane -D'
      bind-key -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k'  'select-pane -U'
      bind-key -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l'  'select-pane -R'

      bind-key -n M-h if -F "#{@pane-is-vim}" 'send-keys M-h' 'resize-pane -L 3'
      bind-key -n M-j if -F "#{@pane-is-vim}" 'send-keys M-j' 'resize-pane -D 3'
      bind-key -n M-k if -F "#{@pane-is-vim}" 'send-keys M-k' 'resize-pane -U 3'
      bind-key -n M-l if -F "#{@pane-is-vim}" 'send-keys M-l' 'resize-pane -R 3'

      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key 'C-h' select-pane -L
      bind-key 'C-j' select-pane -D
      bind-key 'C-k' select-pane -U
      bind-key 'C-l' select-pane -R
      bind-key 'C-\' select-pane -l

      bind Enter new-window -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind h split-window -v -c "#{pane_current_path}"
      bind e kill-pane
      bind m new-session -A -s main
      bind s choose-session
      bind n new-session

      set -g status off
      set-hook -g after-new-window      'if "[ #{session_windows} -gt 1 ]" "set status on"'
      set-hook -g after-kill-pane       'if "[ #{session_windows} -lt 2 ]" "set status off"'
      set-hook -g pane-exited           'if "[ #{session_windows} -lt 2 ]" "set status off"'
      set-hook -g window-layout-changed 'if "[ #{session_windows} -lt 2 ]" "set status off"'

      set-option -g renumber-windows on
      set -g base-index 0
      setw -g pane-base-index 0

      set -g mouse on
    '';
  };
}
