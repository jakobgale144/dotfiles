{ den, ... }:
{
  den.aspects.desktop.includes = [
    den.aspects.niri
    den.aspects.noctalia
    den.aspects.greetd
  ];

  den.aspects.niri = den.lib.parametric {
    nixos.programs.niri.enable = true;

    includes = [
      ({ user, ... }: {
        hjem.${user.userName}.files = { # todo: not sure if this is necessary...
          "niri/config".source = "./config/niri-config.kdl";
          "niri/keybindings".source = "./config/niri-keybindings.kdl";
        };
      })
    ];
  };

  den.aspects.noctalia = den.lib.parametric {
    includes = [
      ({ user, ... }: { # todo: using a lot of parametrics...
        hjem.${user.userName} = { pkgs, ... }: {
          packages = [ pkgs.noctalia-shell ];

          systemd.services."noctalia-shell" = {
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
      })
    ];
  };
  
  den.aspects.greetd = den.lib.parametric {
    includes = [
      ({ user, ... }: {
        nixos.services.greetd.settings.default_session.user = "notARealUserName"; # todo: fix
      })
    ];

    nixos = { pkgs, ... }: {
      # services.xserver.enable = false; # Necessary?
      services.greetd = {
        enable = true;
        settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      };
    };  
  };
}
