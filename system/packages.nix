{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    helix
    wezterm
    git
  ];

  programs.niri.enable = true;
  programs.firefox.enable = true;
}
