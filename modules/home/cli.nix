{
  pkgs,
  inputs,
  ...
}: let
  devinit = pkgs.writeShellScriptBin "devinit" ''
    git init
    devenv init

    cat > .envrc <<'EOF'
    eval "$(devenv direnvrc)"
    use devenv
    EOF

    direnv allow
  '';
in {
  home.packages = with pkgs; [
    devinit
    fd
    cloc
    devenv
    ripgrep
    findutils
    unzip
    pciutils
    killall
    fastfetch
    gdu
    fzf
    gh
    xdg-utils
    wl-clipboard
    eza
    devenv
    brightnessctl
    tree
    file
    jq
    inputs.systemd-manager-tui.packages.x86_64-linux.default
    ffmpeg-full
    yt-dlp
  ];

  home.shellAliases = {
    cd = "z";
    cat = "bat";
    shit = "shutdown";
    ls = "eza --color=always --group-directories-first --icons";
    lsa = "eza --color=always --all --group-directories-first --long --icons --no-permissions --git";
    lg = "lazygit";
    xo = "xdg-open";
    n = "nvim";
    e = "exit";
    ga = "git add";
    gc = "git commit";
    gs = "git status";
    gp = "git push";
    gpl = "git pull";
    hms = "nh home switch";
    nos = "nh os switch";
    stm = "systemd-manager-tui";
  };

  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.television.enable = true;

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = {
      compress = pkgs.yaziPlugins.compress;
    };
    keymap = {
      mgr.prepend_keymap = [
        {
          on = ["c" "a" "a"];
          run = "plugin compress";
          desc = "Archive selected files";
        }
        {
          on = ["c" "a" "p"];
          run = "plugin compress -p";
          desc = "Archive selected files (password)";
        }
        {
          on = ["c" "a" "h"];
          run = "plugin compress -ph";
          desc = "Archive selected files (password+header)";
        }
        {
          on = ["c" "a" "l"];
          run = "plugin compress -l";
          desc = "Archive selected files (compression level)";
        }
        {
          on = ["c" "a" "u"];
          run = "plugin compress -phl";
          desc = "Archive selected files (password+header+level)";
        }
      ];
    };
  };
  programs.zoxide.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/apexu/.dotfiles";
  };
}
