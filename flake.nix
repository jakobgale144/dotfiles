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
    import-tree.inputs.nixpkgs.follows = "nixpkgs";
    # Den
    den.url = "github:vic/den";
    den.inputs.nixpkgs.follows = "nixpkgs";

    # Hjem
    hjem.url = "github:feel-co/hjem";
    hjem.inputs.nixpkgs.follows = "nixpkgs";

    # Preservation
    preservation.url = "github:nix-community/preservation";
    preservation.inputs.nixpkgs.follows = "nixpkgs";

    # Noctalia
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    # Yazelix
    yazelix.url = "github:luccahuguet/yazelix";
    yazelix.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };
}
