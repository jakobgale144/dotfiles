{ self, inputs, ... }:
{
  flake.nixosModules.user = { vars, ... }: {
    imports = [
      self.nixosModules.packages
      self.nixosModules.desktop
    ];
    users.users.root.initialPassword = "password";
    users.users.${vars.username} = {
      initialPassword = "password";
      isNormalUser = true;
      extraGroups = ["wheel"];
    };

    systemd.user.startServices = "sd-switch";
  };
}
