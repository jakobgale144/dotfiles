{ den, inputs, ... }:
{
  imports = [ inputs.den.flakeModule ];

  den.default = {
    nixos.system.stateVersion = "25.11";

    includes = [
      den._.define-user
      den._.hostname
    ];
  };

  den.schema.host = { lib, ... }: {
    options.bootUuid = lib.mkOption;
    options.primaryUuid = lib.mkOption;
  };
}
