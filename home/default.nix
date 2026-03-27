{
  inputs,
  vars,
  ...
}: let
  inherit (inputs) home-manager;
in {
  homeConfigurations."${vars.username}" = home-manager.lib.homeManagerConfiguration {
    inherit inputs; 
    pkgs = nixpkgs.legacyPackages.${system};

    # imports = [ home-manager.nixosModules.home-manager ]; # What does this do?
    modules = [
      ./packages.nix
      ./user.nix
      ./desktop
    ];
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
