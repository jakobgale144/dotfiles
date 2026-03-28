{ den, ... }
{
  den.aspects.test = { user, ... }: {
    includes = [
      den.aspects.desktop
      den.aspects.packages
    ];

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
