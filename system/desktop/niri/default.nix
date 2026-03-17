{
  # pkgs,
  # config,
  ...
}:
{
  # xdg.configFile =
  # let
  #   mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  #   confPath = "${config.home.homeDirectory}/NixOS/system/desktop/nix";
  # in {
  #   "niri/config.kdl".source = mkSymlink "${confPath}/config.kdl";
  #   "niri/keybindings.kdl".source = mkSymlink "${confPath}/keybindings.kdl";
  # };
}
