{ ... }:
let
  primaryUuid = "c5903369-fc45-44f8-b248-ef7260f24e92";
  bootUuid = "5928-46CE";
in {
  flake.nixosModules.test-laptop = { ... }: {
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

    boot.initrd.luks.devices."crypt".device = "/dev/disk/by-uuid/${primaryUuid}";

    fileSystems."/boot".device = "/dev/disk/by-uuid/${bootUuid}";
  };
}
