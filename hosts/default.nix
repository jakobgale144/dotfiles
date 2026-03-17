{
  self,
  vars,
  ...
}: let
  inherit (self) inputs;
  inherit (inputs) nixpkgs home-manager;
  mkHost = hostname: system: nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs vars;
      flake = self;
    };

    modules = [
      {
        networking.hostName = hostname;
        nixpkgs.hostPlatform = system;
      }
      ../system
      ./${hostname}
    ];
  };
in {
  test-laptop = mkHost "test-laptop" "x86_64-linux";
}
