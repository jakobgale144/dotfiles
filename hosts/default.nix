{
  nixpkgs,
  self,
  inputs,
  myvars,
  ...
}: let
  mkHost = hostname: system: nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs myvars;
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
