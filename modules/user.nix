{ den, ... }:
{
  den.aspects.test = { user, ... }: {
    includes = [
       den._.primary-user
      (den._.user-shell "nushell")

       den.aspects.desktop
       den.aspects.packages
    ];

    nixos = {
      users.users.root.initialPassword = "jkl";
      users.users.${user.userName} = {
        initialPassword = "jkl";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    };
  };
}
