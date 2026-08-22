{
...
}:
{
  imports =[
    ../../packages/gpu-screen-recorder-ui/module.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      gpu-screen-recorder-notification = final.callPackage ../../packages/gpu-screen-recorder-ui/gpu-screen-recorder-notification.nix {};
      gpu-screen-recorder-ui = final.callPackage ../../packages/gpu-screen-recorder-ui/package.nix {};
    })
  ];

  programs.gpu-screen-recorder-ui.enable = true;
}
