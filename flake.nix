{
  description = "first flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    settings = {
      de = "hyprland";
      theme = "tokyo-night-terminal-dark";
      launcher = "fuzzel";
      de-shell = "quickshell";
    };
  in {
    nixosConfigurations = {
      iusenixbtw = lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
          inherit settings;
        };
        modules = [
          ./system/configuration.nix
        ];
      };
    };
    homeConfigurations = {
      apexu = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit settings;
        };
        modules = [
          ./user/home.nix
        ];
      };
    };
  };
}
