{ den, inputs, ... }:
{
  den.aspects.desktop.includes = [
    den.aspects.niri
    den.aspects.noctalia
    den.aspects.greetd
  ];

  den.aspects.niri = {
    nixos = { ... }: { programs.niri.enable = true; }; # todo: need to be a function?
    hjem.files = {
      ".config/niri/config.kdl".source = ./config/niri-config.kdl;
      ".config/niri/keybindings.kdl".source = ./config/niri-keybindings.kdl;
    };
  };

  den.aspects.noctalia = { host, ... }: {
    hjem.packages = [
      inputs.noctalia.packages.${host.system}.default
    ];

    nixos.nix.settings = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzWPp3dkU4=" ];
    };

    hjem.systemd.services."noctalia-shell" = {
      description = "Start Noctalia after Niri";
      after = [ "niri.service" ];
      partOf = [ "graphical-session.target" ];
      script = "${inputs.noctalia}/bin/noctalia";
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
