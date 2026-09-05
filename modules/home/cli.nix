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
    ls = "eza --color=always --group-directories-first --icons always";
    lsa = "eza --color=always --all --group-directories-first --long --icons always --no-permissions --git";
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
  programs.zoxide.enable = true;

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    plugins = {
      compress = pkgs.yaziPlugins.compress;
      toggle-pane = pkgs.yaziPlugins.toggle-pane;
      wl-clipboard = pkgs.yaziPlugins.wl-clipboard;
      mount = pkgs.yaziPlugins.mount;
    };
    settings = {
      mgr = {
        ratio = [0 4 2];
        linemode = "size";
      };
    };
    initLua = ''
      if os.getenv("NVIM") then
      	require("toggle-pane"):entry("min-preview")
      end
    '';
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
        {
          on = "P";
          run = "plugin toggle-pane min-preview";
          desc = "Show or hide the preview pane";
        }
        {
          on = "<C-y>";
          run = ["plugin wl-clipboard"];
          desc = "Copy seleted items";
        }
        {
          on = "M";
          run = "plugin mount";
          desc = "Manage mounts";
        }
      ];
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/jzep/.dotfiles";
  };

  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      search_mode = "prefix";
    };
  };
}
