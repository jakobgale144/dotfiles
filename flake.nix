{
  description = "Test Nix Flake config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Nixpkgs Unstable
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Preservation
    preservation.url = "github:nix-community/preservation";
  };

  outputs = {
    self,
    nixpkgs,
    # nixpkgs-unstable,
  } @ inputs: {
    nixosConfigurations = import ./hosts inputs;
  };
}
