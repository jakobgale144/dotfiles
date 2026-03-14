{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    helix
    wezterm
    git
  ];

  programs.niri.enable = true;
  programe.firefox.enable = true;
}
