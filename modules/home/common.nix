{config, ...}: {
  imports = [
    ./cli.nix
    ./shell/fish.nix
    ./git.nix
  ];

  config = {
    _module.args.link = config.lib.file.mkOutOfStoreSymlink;
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
    home.pointerCursor.enable = true;

    nixpkgs.config.allowUnfree = true;
  };
}
