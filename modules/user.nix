{ den, ... }:
{
  den.aspects.test = { user, ... }: {
    includes = [
       den._.primary-user

       den.aspects.preserve-home
       den.aspects.desktop
       den.aspects.packages
    ];

    user = { pkgs, ... }: {
      initialPassword = "jkl";
      isNormalUser = true;
      extraGroups = [ "wheel" ];

      # shell = pkgs.nushell;
    };

    nixos.users.users.root.initialPassword = "jkl";
  };
}
