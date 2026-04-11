{ den, ... }:
{
  den.aspects.desktop.includes = [
    den.aspects.niri
    den.aspects.noctalia
    den.aspects.greetd
  ];

  den.aspects.niri = {
    nixos.programs.niri.enable = true; # todo: need to be a function?
    hjem.files = {
      ".config/niri/config.kdl".source = ./config/niri-config.kdl;
      ".config/niri/keybindings.kdl".source = ./config/niri-keybindings.kdl;
    };
  };

  den.aspects.noctalia = {
    hjem = { pkgs-unstable, lib, ... }: {
      packages = [
        pkgs-unstable.noctalia-shell
      ];

      systemd.services."noctalia-shell" = {
        description = "Start Noctalia after Niri";
        after = [ "niri.service" ];
        partOf = [ "graphical-session.target" ];
        script = "${pkgs-unstable.noctalia-shell}/bin/noctalia-shell";
        wantedBy = [ "graphical-session.target" ];
        environment.PATH = lib.mkForce "/run/current-system/sw/bin";
      };

      files = {
        ".config/noctalia" = {
          source = ./config/noctalia;
          type = "copy"; # todo: remove when done
        };
        ".config/helix/themes/noctalia.toml".source = ./config/noctalia/helix-theme.toml; # todo: move the below
        ".config/niri/noctalia.toml".source = ./config/noctalia/niri-theme.kdl;
        ".config/wezterm/colors/Noctalia.toml".source = ./config/noctalia/wezterm-theme.toml;
        ".config/yazi/flavors/noctalia.yazi/flavor.toml".source = ./config/noctalia/yazi-theme.toml;
        ".cache/noctalia/zen-browser/zen-userChrome.css".source = ./config/noctalia/zen-theme-chrome.css;
        ".cache/noctalia/zen-browser/zen-userContent.css".source = ./config/noctalia/zen-theme-content.css;
      };
    };

    nixos = { # For Noctalia features
      networking.networkmanager.enable = true;
      hardware.bluetooth.enable = true;
      services.tuned.enable = true;
      services.upower.enable = true;
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
