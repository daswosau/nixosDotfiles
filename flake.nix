{
  description = "Daswosau's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
    # home manager
    #home-manager = {
    #  url = "github:nix-community/home-manager/release-26.05";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    # claude desktop
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    # wayland scroll factor
    wsf = {
      url = "github:daniel-g-carrasco/wayland-scroll-factor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, claude-desktop, wsf, flake-utils }: {
    nixosConfigurations.dwsthinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix # input modules 

        #home-manager.nixosModules.home-manager {
        #  home-manager.useGlobalPkgs = true;
        #  home-manager.useUserPackages = true;
        #  home-manager.users.daswosau = import ./home.nix;
        #}

        wsf.nixosModules.default { 
          programs.wsf.enable = true; 
        }

        
      ];
    };
  };
}