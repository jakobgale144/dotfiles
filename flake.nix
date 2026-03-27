{
  description = "Test Nix Flake config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # Nixpkgs Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake Parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    # Import Tree
    import-tree.url = "github:vic/import-tree";

    # Hjem
    hjem.url = "github:feel-co/hjem";

    # Wrapper Modules
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # Preservation
    preservation.url = "github:nix-community/preservation";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (
    inputs.import-tree ./modules;
  );
}
