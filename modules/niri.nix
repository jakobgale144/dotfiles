{ den, ... }:
{
  den.aspects.desktop.includes = [
    den.aspects.niri
    den.aspects.niri-config
    den.aspects.noctalia
    den.aspects.greetd
  ];

  den.aspects.niri = {
    nixos.programs.niri.enable = true;
  };

  den.aspects.niri-config = {
    hjem.files = { # todo: not sure if this is necessary...
      "niri/config".source = "./config/niri-config.kdl";
      "niri/keybindings".source = "./config/niri-keybindings.kdl";
    };
  };

  den.aspects.noctalia = { pkgs, ... }: {
    hjem.packages = [ pkgs.noctalia-shell ];
    hjem.systemd.services."noctalia-shell" = {
      Unit = {
        Description = "Start Noctalia after Niri";
        After = "niri.service";
        PartOf = "graphical-session.target";
      };

      Service = {
        ExecStart = "${pkgs.noctalia-shell}/bin/noctalia";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
  
  den.aspects.greetd.nixos = { pkgs, ... }: {
    # services.xserver.enable = false; # Necessary?
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      settings.default_session.user = "notARealUserName"; # todo: fix
    };  
  };
}
