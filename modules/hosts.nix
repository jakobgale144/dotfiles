{ self, inputs, ... }:
{
  flake.nixosConfigurations.test-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      {
        networking.hostName = "test-laptop";
        nixpkgs.hostPlatform = "x86_64-linux";
      }
      self.nixosModules.test-laptop
      self.nixosModules.system
      self.nixosModules.user
    ];
  };
}
