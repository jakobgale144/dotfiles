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
      users.users.root.initialPassword = " ";
      users.users.${vars.username} = {
        initialPassword = " ";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    };
  };
}
