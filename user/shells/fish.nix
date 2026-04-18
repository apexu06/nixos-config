{pkgs, ...}: {
  home.packages = with pkgs; [
    nix-your-shell
    python3
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      if not set -q TMUX; and test "$TERM" = "foot"
          exec tmux new-session
      end

      set fish_greeting

      set -U pure_check_for_new_release false
      set -U pure_enable_single_line_prompt true
      set -U pure_sow_subsecond_command_duration true
      set -U pure_shorten_prompt_current_directory_length 1
      set -U pure_enable_nixdevshell true
      set -U __done_min_cmd_duration 10000
      # set -g async_prompt_functions _pure_prompt_git

      fish_vi_key_bindings
      bind --mode insert \cf forward-char

      zoxide init fish | source
      nix-your-shell fish | source
    '';
    plugins = [
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
      {
        name = "pisces";
        src = pkgs.fishPlugins.pisces.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
    ];
    functions = {
      og.body = ''
        set -l path (tv git-repos)
        if test -z $path
          return
        end

        cd $path
        nvim .
      '';
      of.body = ''
        set file (tv files)
        test -n "$file"; and nvim $file
      '';
      off.body = ''
        set folder (tv dirs)
        test -n "$folder"; and nvim $folder
      '';
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
