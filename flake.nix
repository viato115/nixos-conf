{ description = "My main NixOS flake!";
  inputs = {
    nixpkgs = {
      url = github:nixos/nixpkgs/nixos-unstable;
    };

#    sops-nix = {
#      url = github:Mic92/sops-nix;
#      inputs.nixpkgs.follows = "nixpkgs"; 
#    };

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

    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    self,
    nixpkgs, 
    #    sops-nix,
    home-manager, 
    nixos-hardware, 
    hyprland, 
    flake-utils,
    nvf,
    ... 
  }@inputs:

    let
      username = "nico";
      pkgs =  import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
        };
      lib = nixpkgs.lib;

      sharedHomeModules = [
        ./users/nico/home.nix
        hyprland.homeManagerModules.default
        { wayland.windowManager.hyprland.enable = true; }
      ];

    in

  { 
    nixosConfigurations = {
      nixpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
        specialArgs = { 
          inherit self inputs username; 
          host = "nixpad";
        };
        modules = [ 
          ./hosts/nixpad/default.nix 
          nixos-hardware.nixosModules.lenovo-thinkpad-l13-yoga
            #      sops-nix.nixosModules.sops
        ];
      };

      nixtop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { 
          inherit self inputs username; 
          host = "nixtop";
        };
        modules = [ 
          ./hosts/nixtop/default.nix 
            # sops-nix.nixosModules.sops
        ];
      };
    };

    homeConfigurations = {
      "nico@nixpad" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; hostname = "nixpad"; };
        modules = sharedHomeModules;
      };

      "nico@nixtop" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; hostname = "nixtop"; };
        modules = sharedHomeModules;
      };
    };
  };
}
