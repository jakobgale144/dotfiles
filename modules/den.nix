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
    options.bootUuid = lib.mkOption {
      type = lib.types.str;
      description = "UUID of the disk's boot partition";
    };
    options.primaryUuid = lib.mkOption {
      type = lib.types.str;
      description = "UUID of the disks's primary (LUKS) partition";
    };
  };
}
