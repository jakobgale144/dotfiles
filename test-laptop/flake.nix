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
  in {
    imports = [

    ];
    nixosConfigurations.test-laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        ./boot-configuration.nix
        ./packages.nix
        ./hardware-configuration.nix
      ];
    };
  };
}
