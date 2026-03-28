{ den, ... }:
{
  den.aspects.test = {
    includes = [
      den.aspects.desktop
      den.aspects.packages
    ];

    hjem = {
     user = "test";
     directory = "/home/test"; 
    };

    nixos = {
      users.users.root.initialPassword = "jkl";
      users.users.test = {
        initialPassword = "jkl";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
    };
  };
}
