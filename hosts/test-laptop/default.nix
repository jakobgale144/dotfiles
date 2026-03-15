{ ... }:
let
  hostvars = import ./vars.nix;
in {
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

  boot.initrd.luks.devices."crypt".device = "/dev/disk/by-uuid/${hostvars.test-laptop.primary_uuid}";

  # Our boot device
  fileSystems."/boot".device = "/dev/disk/by-uuid/${hostvars.test-laptop.boot_uuid}";
};
