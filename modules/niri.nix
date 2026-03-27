{ self, inputs, ... }:
{
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri.enable = true;
    programs.niri.package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
  };

  perSystem = { self', lib, pkgs, ... }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      settings.spawn-at-startup = { command = [ (lib.getExe self'.packages.noctalia) ]; };
      "config.kdl".path = ./config.kdl;
    };
  };
}
