{
  nixpkgs,
  inputs,
  self,
  ...
}: let
  mkHost = hostname: system: nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      flake = self;
    };

    modules = [
      {
        networking.hostName = hostname;
        nixpkgs.hostPlatform = system;
      }
      ../system
      ../user
      ./${hostname}
    ];
  };
in {
  test-laptop = mkHost "test-laptop" "x86_64-linux";
}
