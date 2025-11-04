{
  pkgs,
  settings,
  ...
}: {
  imports = [
    ./stylix.nix
    ./xdg.nix
    ./shells/fish.nix
    ./shells/cli-utils.nix
    ./de/${settings.de}/${settings.de}.nix
    ./app/neovim/nvim.nix
    ./app/browser/zen.nix
    ./app/vesktop.nix
    ./app/terminal/wezterm.nix
    ./app/git.nix
    ./app/thunderbird.nix
    ./app/shell/quickshell/quickshell.nix
  ];
  home.username = "apexu";
  home.homeDirectory = "/home/apexu";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    protonmail-desktop
    spotifywm
    vlc
    obsidian
    vscode
    devenv
  ];

  nixpkgs.config.allowUnfree = true;

  home.stateVersion = "25.05"; # Please read the comment before changing.
  home.sessionVariables = {
    EDITOR = "nvim";
    SHELL = "fish";
    QT_QPA_PLATFORM = "wayland";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/.nix-profile/share/applications"
  ];

  # systemd.user.services.nm-applet = {
  #   Unit = {
  #     Description = "Disabled nm-applet";
  #   };
  #   Install.WantedBy = [ ];
  #   Service.ExecStart = "${pkgs.coreutils}/bin/true";
  # };

  programs.home-manager.enable = true;
}
