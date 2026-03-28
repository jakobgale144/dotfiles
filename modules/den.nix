{ den, inputs, ... }:
{
  imports = [ inputs.den.flakeModule ];

  den.default = {
    nixos.system.stateVersion = "25.11";

    includes = [
      den.provides.define-user
      den.provides.hostname
    ];
  };

  den.schema.host.hjem.enable = true;
}
