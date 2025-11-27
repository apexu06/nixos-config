{
  description = "quickshell";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "quickshell-dev";

      buildInputs = with pkgs; [
        kdePackages.qtdeclarative
        libnotify
      ];
    };
  };
}
