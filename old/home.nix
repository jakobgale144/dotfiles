{ config, pkgs, ... }:

{
  home.username = "test";
  home.homeDirectory = "/home/test";

  # wayland.windowManager.hyprland.enable = true;

  home.packages = with pkgs; [
    zoxide
  ];

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
