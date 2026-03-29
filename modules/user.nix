{ den, ... }:
{
  den.aspects.test = { user, ... }: {
    includes = [
       den._.primary-user
      (den._.user-shell "fish") # todo: why does nushell not work?

       den.aspects.desktop
       den.aspects.packages
    ];

    user = {
      initialPassword = "jkl";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    nixos.users.users.root.initialPassword = "jkl";
  };
}
