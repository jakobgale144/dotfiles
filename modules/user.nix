{ den, ... }:
{
  den.aspects.test = { user, ... }: {
    includes = [
       den._.primary-user
      (den._.user-shell "fish")

       den.aspects.desktop
       den.aspects.packages
    ];

    classes = [ "hjem" ]; # todo: comment out one by one to see if necessary

    hjem = {
     user = user.userName;
     directory = "/home/${user.userName}"; 
    };

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
