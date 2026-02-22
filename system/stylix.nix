{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix.autoEnable = true;
}
