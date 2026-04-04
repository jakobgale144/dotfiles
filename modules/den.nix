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

  den.schema.host = { lib, pkgs, ... }: {
    options.bootUuid = lib.mkOption {
      type = lib.types.str;
      description = "UUID of the disk's boot partition";
    };
    options.primaryUuid = lib.mkOption {
      type = lib.types.str;
      description = "UUID of the disks's primary (LUKS) partition";
    };

    config._module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
      system = pkgs.system;
      config.allowUnfree = true;
    };
  };
}
