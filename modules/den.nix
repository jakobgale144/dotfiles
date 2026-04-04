{ den, inputs, ... }:
{
  imports = [ inputs.den.flakeModule ];

  den.default = {
    includes = [
      den._.define-user
      den._.hostname
    ];

    nixos = { pkgs, ... }: {
      nixos.system.stateVersion = "25.11";

      # Create a pkgs-unstable module to easily access unstable nixpkgs
      _module.args.pkgs-unstable = import inputs.nixpkgs-unstable {
        system = pkgs.system;
        config.allowUnfree = true;
      };
    };
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
  };
}
