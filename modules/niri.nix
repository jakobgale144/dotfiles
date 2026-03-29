{ den, ... }:
{
  den.aspects.desktop.includes = [
    den.aspects.niri
    den.aspects.noctalia
    den.aspects.greetd
  ];

  den.aspects.niri = {
    nixos.programs.niri.enable = true;

    hjem.files = {
      "niri/config".source = "./config/niri-config.kdl";
      "niri/keybindings".source = "./config/niri-keybindings.kdl";
    };
  };

  den.aspects.noctalia = {
    hjem = { pkgs, ... }: {
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
  };
  
  den.aspects.greetd = den.lib.parametric {
    includes = [
      ({ user, ... }: {
        nixos.services.greetd.settings.default_session.user = user.userName;
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
