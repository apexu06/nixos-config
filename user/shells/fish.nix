{pkgs, ...}: {
  home.packages = with pkgs; [
    fishPlugins.pure
    fishPlugins.fzf-fish
    fishPlugins.done
    fishPlugins.async-prompt
    nix-your-shell
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting

      set -U pure_check_for_new_release false
      set -U pure_enable_single_line_prompt true
      set -U pure_sow_subsecond_command_duration true
      set -U pure_shorten_prompt_current_directory_length 1
      set -U pure_enable_nixdevshell true
      set -U __done_min_cmd_duration 10000
      set -g async_prompt_functions _pure_prompt_git

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
        test -n "$folders"; and nvim $folders
      '';
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
