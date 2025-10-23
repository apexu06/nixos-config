{
  description = "first flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
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

    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    apple-fonts,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    settings = {
      de = "hyprland";
      theme = "tokyo-night-terminal-dark";
      launcher = "tofi";
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
          inherit apple-fonts;
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
