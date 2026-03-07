{
  description = "Test Nix Flake config"

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Nixpkgs Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
  }: let
  in {
    nixosConfigurations.test-laptop = nixpkkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [./nixos/configuration.nix];
    };
  };
}
