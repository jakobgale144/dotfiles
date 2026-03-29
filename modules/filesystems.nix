{ den, ... }:
{
  den.aspects.filesystems.nixos = primaryUuid: bootUuid: {
    boot.initrd.luks.devices."crypt".device = "/dev/disk/by-uuid/${primaryUuid}";

    # We can access all of BTRFS' subvolumes from /pool
    fileSystems."/pool" = {
      device = "/dev/mapper/crypt";
      fsType = "btrfs";
      options = [ "subvolid=5" ]; # The ID used for the BTRFS subvolume pool
    };

    # Root filesystem
    fileSystems."/" = {
      device = "tmpfs"; # Erase your darlings!
      fsType = "tmpfs";
      options = [
        "relatime"
        "mode=755" # systemd defaults to 777, which sometimes causes problems
      ];
    };

    # Nix store
    fileSystems."/nix" = {
      device = "/dev/mapper/crypt";
      fsType = "btrfs";
      options = [ 
        "subvol=@nix"
        "compress-force=zstd:1" # Force level 1 ZSTD compression on all files; quickest, most bang-for-buck
        "relatime"              # Write access time relative to it's creation/modification time
      ];
    };

    # Persistent directory; pats of our root that need to persist between boots
    fileSystems."/persist" = {
      device = "/dev/mapper/crypt";
      fsType = "btrfs";
      options = [ 
        "subvol=@persist"
        "compress-force=zstd:1"
        "relatime"
      ];
      neededForBoot = true;
    };

    # Holds our BTRFS snapshots
    fileSystems."/snapshots" = {
      device = "/dev/mapper/crypt";
      fsType = "btrfs";
      options = [ 
        "subvol=@snapshots"
        "compress-force=zstd:1"
        "relatime"
      ];
    };

    # The location of our swapfile (read only)
    fileSystems."/swap" = {
      device = "/dev/mapper/crypt";
      fsType = "btrfs";
      options = [ 
        "subvol=@swap"
        "ro"
      ];
    };

    # Our swapfile itself (read/write)
    fileSystems."/swap/swapfile" = {
      depends = [ "/swap" ];
      device = "/swap/swapfile";
      fsType = "none";
      options = [
        "bind" # Bind means we're mounting this directory within another directory
        "rw"
      ];
    };

    swapDevices = [ # Point Nix in the direction of our swapfile, which is not a separate partition; hence the curly brackets
      { device = "/swap/swapfile"; }
    ];

    # Our boot device
    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/${bootUuid}";
      fsType = "vfat";
      options = [ 
        "fmask=0177" # File mask:      Owner rw-, Group/Others ---
        "dmask=0077" # Directory mask: Owner rwx, Group/Others ---
        "noexec,nosuid,nodev" # Block execution, ignore setuid, and disable device nodes
      ];
    };
  };
}
