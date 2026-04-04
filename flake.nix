{
  description = "Test Nix Flake config";

    outputs = inputs:
    (inputs.nixpkgs.lib.evalModules {
      modules = [ (inputs.import-tree ./modules) ];
      specialArgs.inputs = inputs;
    }).config.flake;

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    # Nixpkgs Unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Import Tree
    import-tree.url = "github:vic/import-tree";
    # Den
    den.url = "github:vic/den";

    # Hjem
    hjem.url = "github:feel-co/hjem";

    # Preservation
    preservation.url = "github:nix-community/preservation";

    # Noctalia
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    # Yazelix
    yazelix.url = "github:luccahuguet/yazelix";
    yazelix.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };
}
