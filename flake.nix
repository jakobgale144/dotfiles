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
    ...
  } @ inputs: let
    myvars = import ./system/vars;
  in {
    nixosConfigurations = import ./hosts { inherit inputs myvars self; };
  };
}
