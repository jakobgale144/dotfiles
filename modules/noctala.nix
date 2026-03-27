{ self, inputs, ... }:
{
  perSystem = { pkgs, ... }: {
    packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
    };
  };
}
