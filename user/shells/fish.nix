{pkgs, ...}: {
  home.packages = with pkgs; [
    fishPlugins.pure
    fishPlugins.fzf-fish
    fishPlugins.done
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting

      set -U pure_check_for_new_release false
      set -U pure_enable_single_line_prompt true
      set -U pure_sow_subsecond_command_duration true
      set -U pure_shorten_prompt_current_directory_length 1
      set -U __done_min_cmd_duration 10000

      fish_vi_key_bindings
      bind --mode insert \cf forward-char

      zoxide init fish | source
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
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
