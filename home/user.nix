{
  home-manager,
  vars,
  ...
}:
{
  home = {
    username = vars.username;
    homeDirectory = "/home/${vars.username}";
  };

  users.users.root.initialPassword = "password";
  users.users.${vars.username} = {
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
