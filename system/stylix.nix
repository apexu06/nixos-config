{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix.autoEnable = true;
  stylix.targets.console.enable = true;
  stylix.targets.gnome.enable = true;
  stylix.targets.qt.enable = true;
  stylix.targets.gtk.enable = true;
}
