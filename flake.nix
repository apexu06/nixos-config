{
  description = "first flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae.url = "github:vicinaehq/vicinae";

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
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

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay/0d454d45604a3215057806757beda9bc7390d59e";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
      "https://vicinae.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    settings = {
      de = "niri";
      theme = "gruvbox-material";
      useWallpaper = true;
      launcher = "noctalia";
      de-shell = "noctalia";
    };
  in {
    nixosConfigurations = {
      pc = lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
          inherit settings;
        };
        modules = [
          ./system/pc-hardware-configuration.nix
          ./system/configuration.nix
          ./system/pc.nix
        ];
      };
      laptop = lib.nixosSystem {
        specialArgs = {
          inherit system;
          inherit inputs;
          inherit settings;
        };
        modules = [
          nixos-hardware.nixosModules.framework-13-7040-amd
          ./system/laptop-hardware-configuration.nix
          ./system/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      pc = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit settings;
        };
        modules = [
          ./user/home.nix
          ./user/pc.nix
        ];
      };

      laptop = home-manager.lib.homeManagerConfiguration {
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
