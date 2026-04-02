{ den, inputs, ... }:
{
  den.aspects.desktop.includes = [
    den.aspects.niri
    den.aspects.noctalia
    den.aspects.greetd
  ];

  den.aspects.niri = {
    nixos = { ... }: { programs.niri.enable = true; };
    hjem.files = { # todo: not sure if this is necessary...
      ".config/niri/config.kdl".source = ./config/niri-config.kdl;
      ".config/niri/keybindings.kdl".source = ./config/niri-keybindings.kdl;
    };
  };

  den.aspects.noctalia.hjem = {
    systemd.services."noctalia-shell" = {
      description = "Start Noctalia after Niri";
      after = "niri.service";
      partOf = "graphical-session.target";
      postStart = "${inputs.noctalia}/bin/noctalia";
      wantedBy = [ "graphical-session.target" ];
    };
  };

  den.aspects.greetd = { user, ... }: {
    nixos = { pkgs, ... }: {
      # services.xserver.enable = false; # Necessary?
      services.greetd = {
        enable = true;
        settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        settings.default_session.user = user.userName; # todo: fix
      };
    };
  };
}
