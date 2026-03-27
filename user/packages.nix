{ self, inputs, ... }:
{
  flake.nixosModules.packages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      helix
      wezterm
      git
    ];

    programs.firefox.enable = true;
  };
}
