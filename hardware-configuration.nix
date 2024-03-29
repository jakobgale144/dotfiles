# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot = {
    initrd = {
      availableKernelModules = 
      [ "ata_piix" 
        "ohci_pci" 
        "ehci_pci" 
        "ahci" 
        "sd_mod" 
        "sr_mod" ];
      kernelModules = [ ];
      postDeviceCommands = lib.mkAfter ''
        mkdir /mnt
        mount -t btrfs /dev/mapper/crypt
        btrfs subvolume delete /mnt/root
        btrfs subvolume snapshot /mnt/root-blank /mnt/root
      '';
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
    supportedFilesystems = [ "btrfs" ];
  };

  boot.initrd.luks.devices.luksroot = {
    device = "/dev/disk/by-label/luksroot";
    preLVM = true;
    allowDiscards = true;
  };

  fileSystems."/" =
    { device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" "discard" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" "discard" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" "discard" ];
      neededForBoot = true;
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" "discard" ];
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-label/root";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" "discard" ];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  virtualisation.virtualbox.guest.enable = true;
}
