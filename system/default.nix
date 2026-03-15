{
  inputs,
  # config,
  myvars,
  lib,
  pkgs,
  ...
}:
let
  # inherit (myvars) username;
  inherit myvars;
in {
  imports = [
    ./boot.nix
    ./packages.nix
    ./preservation.nix
  ];
  nixpkgs.config.allowUnfree = true; # Allows proprietary packages

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes"; # Enable Flakes and the new "nix" command
      flake-registry = ""; # Disable global registry
    };
    channel.enable = false; # Disable channels

    # Make flake registry and Nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  networking.hostName = "test-laptop";

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  users.users.${username} = {
    initialPassword = "";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  system.stateVersion = "25.11"; # Do you know what you're doing?
}
