{
  den.aspects.system.nixos = { pkgs, ... }: { # todo: comment out, see below
  # inputs, lib, pkgs, ... }:
  # let
  #   flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  # in {
    nixpkgs.config.allowUnfree = true; # Allows proprietary packages
    networking.networkmanager.enable = true;
    time.timeZone = "America/New_York";

    environment.systemPackages = [
      pkgs.git # todo: comment all this out when done testing
    ];

    settings = {
      experimental-features = "nix-command flakes"; # Enable Flakes and the new "nix" command
  #     flake-registry = ""; # Disable global registry
    };
  #   channel.enable = false; # Disable channels

  #   # Make flake registry and Nix path match flake inputs
  #   registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
  #   nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
}
