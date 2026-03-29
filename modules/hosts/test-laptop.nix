{ den, ... }:
{
  den.hosts.x86_64-linux.test-laptop = {
    users.test = { };
    
    primaryUuid = "c5903369-fc45-44f8-b248-ef7260f24e92";
    bootUuid = "5928-46CE";

    classes = [ "hjem" ]; # todo: comment out one by one to see if necessary
    
    hjem.enable =  true; # todo: fix? necessary?
    hjem.clobberByDefault = true;
  };


  den.aspects.test-laptop.includes = [
    den.aspects.boot
    den.aspects.filesystems
    den.aspects.preservation
    den.aspects.system

    den.aspects.test-laptop._.hardware-config
  ];

  den.aspects.test-laptop._.hardware-config.nixos = { lib, config, ... }: {
    boot.initrd.availableKernelModules = [ # todo: add more based on errors 
      "nvme"
      "ahci"
      "usbhid"
      "xhci_pci"
      "usb_storage"
      "sd_mod"
      "sdhci_pci"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ]; # KVM support
    boot.extraModulePackages = [ ];

    # Enable DHCP on device interfaces, both wired and wireless. Hardware specific
    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
