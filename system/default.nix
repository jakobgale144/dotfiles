{
  inputs,
  vars,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./boot.nix
    ./packages.nix
    ./preservation.nix
    ./user.nix
    ./desktop
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

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  users.users.root.initialPassword = "password";
  users.users.${vars.username} = {
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  system.stateVersion = "25.11"; # Do you know what you're doing?
}
