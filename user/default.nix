{ myvars, ... }: let
  inherit (myvars) username;
in {
  users.users.root.initialPassword = "password";
  users.users.${username} = {
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
}
