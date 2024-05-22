{ description = "My main NixOS flake!";
  inputs = {
    nixpkgs = {
      url = github:nixos/nixpkgs/nixos-unstable;
    };

    flake-utils = {
      url = github:numtide/flake-utils;
    };

    nixos-hardware = {
      url = github:nixos/NixOS-hardware/master;
    };

    home-manager = {
      url = github:nix-community/home-manager;
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    xdg-desktop-portal-hyprland = {
      url = github:hyprwm/xdg-desktop-portal-hyprland;
    };

    hyprland = {
      url = git+https://github.com/hyprwm/Hyprland?submodules=1;
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    hyprpaper = {
      url = github:hyprwm/hyprpaper;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = { 
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"; 
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
  };

  outputs = { 
    nixpkgs, 
    home-manager, 
    nixos-hardware, 
    hyprland, 
    flake-utils,
    ... 
  }@inputs:{ 

    nixosConfigurations = {
      nixpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./hosts/nixpad/default.nix 
          nixos-hardware.nixosModules.lenovo-thinkpad-l13-yoga
        ];
      };
    };

  #  nixosConfigurations = {
  #    nixtop = nixpkgs.lib.nixosSystem {
  #      system = "x86_64-linux";
  #      modules = [ 
  #        ./hosts/nixtop/default.nix 
  #      ];
  #    };
  #  };

    homeConfigurations = {
      "nico@nixpad" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
          ./users/nico/home.nix 
          hyprland.homeManagerModules.default
          {wayland.windowManager.hyprland.enable = true;}
        ];
      };
    };
  };
}
