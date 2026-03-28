{
  den.aspects.system.nixos = { lib, pkgs, ... }: {
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
  };
}
