{
  inputs,
  myvars,
  lib,
  pkgs,
  ...
}:
let
  inherit (myvars) username;
in {
  imports = [ inputs.preservation.nixosModules.default ];

  preservation.enable = true;
  preservation.preserveAt."/persist" = {
    directories = [
      /etc/NetworkManager/system-connections
      /etc/ssh
      /etc/nix/inputs
      # /etc/agenix

      /var/log

      /var/lib/nixos
      /var/lib/systemd
      {
        directory = "/var/lib/private";
        mode = "0700";
      }

      # todo: virtualization

      # /var/lib/bluetooth
      /var/lib/NetworkManager
    ];
    
    files = [
      {
        file = "/etc/machine-id";
        inInitrd = true;
      }
    ];

    users.${username} = {
      commonMountOptions = [
        "x-gvfs-hide"
      ];
      directories = [
        # XDG Home Directories
        "Desktop"
        "Documents"
        "Downloads"
        "Pictures"
        "Videos"

        ".cache"

        # Personal Directories
        "Repos"
        "Projects"
        "NixOS"
        "Temp"

        # Nix / Home Manager Profiles
        ".local/state/home-manager"
        ".local/state/nix/profiles"
        ".local/share/nix"

        # todo: editors

        # Language Package Managers
        ".cargo"
        # ".local/share/uv"

        # Security
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".pki"; # todo: look into this...
          mode = "0700";
        }
        # {
        #   directory = ".local/share/password-store";
        #   mode = "0700";
        # }

        # Games
        ".steam"
        # ".config/lutris" # Can this config go anywhere else?
        ".local/share/Steam"
        ".local/share/lutris"

        # Browsers
        ".mozilla"

        # CLI Data
        ".local/share/atuin"
        ".local/share/zoxide"
      ];
    };
  };

  boot.initrd.systemd.enable = true;
  systemd.tmpfiles.settings.preservation =
    let
      permission = {
        user = username;
        group = lib.mkForce username;
        mode = lib.mkForce "0750";
      };
    in {
      "/home/${username}/.config".d = permission;
      "/home/${username}/.local".d = permission;
      "/home/${username}/.local/share".d = permission;
      "/home/${username}/.local/state".d = permission;
      "/home/${username}/.local/state/nix".d = permission;
    };

  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persist/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persist"
    ];
  };
}
