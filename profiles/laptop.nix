{settings, ...}: {
  imports = [
    ../system/stylix.nix
    ../system/pipewire.nix
    ../system/virtualization.nix
    ../system/de/${settings.de}.nix
    ../system/lanzaboote.nix
    ../system/services.nix
  ];
}
