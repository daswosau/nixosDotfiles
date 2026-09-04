{
  description = "Daswosau's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    claude-desktop-linux.url = "github:k3d3/claude-desktop-linux-flake";
    
    wsf = {
      url = "github:daniel-g-carrasco/wayland-scroll-factor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, claude-desktop-linux, wsf }: {
    nixosConfigurations.dwsthinkpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [

        {
          nixpkgs.overlays = [
            (final: prev: {
              claude-desktop = claude-desktop-linux.packages.x86_64-linux.default;
            })
          ];
        }

        wsf.nixosModules.default
        { programs.wsf.enable = true; }

        ./configuration.nix
      ];
    };
  };
}