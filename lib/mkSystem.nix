{inputs}: {
  hostname,
  system,
  theme,
  extraModules ? [],
}:
inputs.home-manager.lib.nixosSystem {
  inherit system;
  specialArgs = {inherit inputs theme hostname;};

  modules =
    [
      ../hosts/${hostname}
      ../modules/nixos/stylix.nix
      ../modules/nixos/common.nix
    ]
    ++ extraModules;
}
