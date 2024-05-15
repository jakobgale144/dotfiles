{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot = {
    initrd = {
      postDeviceCommands = lib.mkAfter ''
        mkdir /mnt
        mount -t btrfs /dev/mapper/crypt
        btrfs subvolume delete /mnt/root
        btrfs subvolume snapshot /mnt/root-blank /mnt/root
      '';
      preLVMCommands = ''
        echo '--- OWNERSHIP NOTICE ---'
        echo 'This device is property of Jakob Gale'
        echo 'If lost please contact jakobgale144@gmail.com'
        echo '--- OWNERSHIP NOTICE ---'
      '';
    };
    supportedFilesystems = [ "btrfs" ];
  };
  
  boot.initrd.luks.devices."crypt" =
  { preLVM = true;
    allowDiscards = true;
  };

  fileSystems."/" =
    { options = [ "compress=zstd" "noatime" "discard" ];
    };

  fileSystems."/home" = 
    { options = [ "compress=zstd" "noatime" "discard" ];
    };

  fileSystems."/nix" =
    { options = [ "subvol=nix" "compress=zstd" "noatime" "discard" ];
      neededForBoot = true;
    };

  fileSystems."/persist" =
    { options = [ "subvol=persist" "compress=zstd" "noatime" "discard" ];
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    { options = [ "subvol=log" "compress=zstd" "noatime" "discard" ];
      neededForBoot = true;
    };
}
