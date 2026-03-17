{ vars, ... }:
{
  users.users.root.initialPassword = "password";
  users.users.${vars.username} = {
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
