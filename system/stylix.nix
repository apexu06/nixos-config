{ inputs, ... }:

{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix.autoEnable = false;
  stylix.targets.console.enable = true;
  stylix.targets.gnome.enable = true;
  stylix.targets.qt.enable = true;
  stylix.homeManagerIntegration.followSystem = true;
}
