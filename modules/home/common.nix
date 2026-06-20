{...}: {
  imports = [
    ./cli.nix
    ./shell/fish.nix
    ./git.nix
  ];

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    SHELL = "fish";
    QT_QPA_PLATFORM = "wayland";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.nix-profile/bin"
    "$HOME/.nix-profile/share/applications"
  ];

  nixpkgs.config.allowUnfree = true;
}
