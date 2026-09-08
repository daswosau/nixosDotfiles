{
  description = "Daswosau's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # claude desktop
    claude-desktop-linux.url = "github:k3d3/claude-desktop-linux-flake";
    # wayland scroll factor
    wsf = {
      url = "github:daniel-g-carrasco/wayland-scroll-factor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, claude-desktop-linux, wsf }: {
    nixosConfigurations.dwsthinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ # input modules

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yourusername = import ./home.nix;
        };

        wsf.nixosModules.default { 
          programs.wsf.enable = true; 
        };

        {nixpkgs.overlays = [
          (final: prev: {
            claude-desktop = claude-desktop-linux.packages.x86_64-linux.default;
          })
        ];}

      ];
      modules = [
        ./configuration.nix
      ];
    };
  };
}