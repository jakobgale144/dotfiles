{
  nixpkgs,
  self,
  ...
}: let
  inherit (self) inputs;
  mkHost = hostname: system: nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit myvars;
      flake = self;
    } // inputs;

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
