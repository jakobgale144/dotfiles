{ den, ... }:
{
  imports = [ inputs.den.flakeModule ];

  den.default = {
    nixos.system.stateVersion = "25.11";

    includes = [
      den.provides.define-user
      den.provides.hostname
      den.provides.inputs'
    ];
  };

  den.schema.host = { host, lib, ... }: {
    config.hjem.module = inputs.hjem.nixosModules.default;
  };

  den.schema.user = { user, lib, ... }: {
    config.classes = lib.mkDefault [ "hjem" ];
  };
}
