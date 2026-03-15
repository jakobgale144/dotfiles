{
  description = "Test Nix Flake config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Nixpkgs Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
  } @ inputs: let
      
    myvars = import ./vars.nix;

    mkHostConfig = hostname: nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs self;
        username = myvars.username;
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
