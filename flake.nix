{
  description = "Test Nix Flake config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Nixpkgs Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

     # Preservation
     preservation.url = "github:nix-community/preservation";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    preservation,
  } @ inputs:
  let
    mkHostConfig = hostname: nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs self;
      };

      modules = [
        ./core
        ./hosts/${hostname}
      ];
    };
  in {
    nixosConfigurations = {
      test-laptop = mkHostConfig "test-laptop";
    };
  };
}
