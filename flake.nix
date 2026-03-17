{
  description = "Test Nix Flake config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Nixpkgs Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager";

    # Preservation
    preservation.url = "github:nix-community/preservation";
  };

  outputs = {
    self,
    ...
  } @ inputs: let
    vars = import ./vars.nix;
  in {
    nixosConfigurations = import ./hosts { inherit self vars; };
  };
}
