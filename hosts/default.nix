{
  nixpkgs,
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
        networking.hostName = name;
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
