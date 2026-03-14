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
    lib,
    nixpkgs,
    nixpkgs-unstable,
  } @ inputs: let
    myVars = import ./vars.nix { inherit lib; };
    mkHostConfig = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs self myvars;
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
