{ self, inputs, ... }:
{
  flake.nixosModules.desktop = { pkgs, vars, ... }: { 
    imports = [
      self.nixosModules.niri
    ];
  
    services.xserver.enable = false;
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      settings.default_session.user = vars.username;
    };
  };
}
